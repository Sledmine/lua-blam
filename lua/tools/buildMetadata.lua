-- This script builds metadata for structs defined in a C header file.
-- It uses the LuaJIT FFI library to parse the header and extract struct information.
-- The metadata includes member names, offsets, sizes, types, and other relevant information.
-- Script is intended to run with a 32 bits LuaJIT interpreter with a patched C parser to properly
-- read __attribute__((packed)) enums.

package.path = package.path .. ";lua/?.lua;lua/modules/?.lua;?.lua"
local luna = require "luna"
local ffi = require "ffi"
local reflect = require "reflect"
local inspect = require "modules.inspect"
local naming = require "naming"
local argparse = require "modules.argparse"

local parser = argparse("buildMetadata", "Build metadata for structs")
parser:argument("header"):description("The header file to parse")
parser:argument("struct"):description("The struct to parse")
parser:flag("-d --debug"):description("Enable debug output")

local args = parser:parse()

local function printdebug(...)
    if args.debug then
        print(...)
    end
end

local function getNativeCType(is, unsigned, size)
    -- Return the native C type based on the Lua type
    if is == "int" or is == "enum" then
        if size then
            if size == 1 then
                return unsigned and "byte" or "char"
            elseif size == 2 then
                return unsigned and "word" or "short"
            elseif size == 4 then
                return unsigned and "dword" or "int"
            elseif size == 8 then
                return unsigned and "qword" or "long"
            end
        end
        return "int"
    elseif is == "float" then
        return "float"
    elseif is == "double" then
        return "double"
    elseif is == "char" then
        return "char"
    elseif is == "bool" then
        return "bool"
    elseif is == "void" then
        return "void"
    else
        return nil -- Unsupported type
    end
end

local function getElementCount(member)
    return assert(math.floor(member.size / member.element_type.size),
                  "Failed to get element count for member: " .. tostring(member.name))
end

local function getStructMembers(structType)
    ---@type table<string, {name: string, offset: number, type: string}>
    local members

    local typeof
    -- local structName = "unknown"
    local structName = "unknown"
    if type(structType) == "string" then
        structName = structType
        -- Struct is a named type
        typeof = reflect.typeof(structType)
    else
        -- Struct is an anonymous type like a union or sub struct
        typeof = structType
    end

    local elementType = typeof.what
    -- TODO Refactor code a bit to work with unions as well
    -- Unions do not have a type cause they also have "members" that need to be merged
    -- with the previous or "parent" member that contains the union
    --if elementType == "struct" or elementType == "union" then
    if elementType == "struct" then
        for member in typeof:members() do
            local fields

            if not member.offset then
                print("Warning: Member without offset found in struct " .. structName)
                member.offset = 0 -- Default to 0 if no offset is provided
            end
            if not member.name then
                print("Warning: Member without name found in struct " .. structName)
                member.name = "unnamed_member_" .. tostring(member)
            end
            -- print("------")
            -- print(inspect(member, {showCycles = true}))
            -- printdebug("Name: " .. member.name, "Offset: 0x" .. string.format("%x", member.offset))

            -- local symName = member.type.sym_name
            local isStruct = member.type.what == "struct" or member.type.what == "union"
            local isEnum = member.type.what == "enum"
            local isArray = member.type.what == "array"
            local isPointer = member.type.what == "ptr"
            local hasElements = isArray or isPointer
            local what = member.what

            printdebug("Member Type:", member.type.what, "Is Struct:", isStruct, "What:", what)
            if isStruct then
                -- If the type is a struct, recursively get its members
                fields = getStructMembers(member.type.name or member.type)
            end

            -- If the type is an enum, we can treat it as an int (for now until we implement enums)
            if isEnum then
                member.type.what = "int"
            end

            if not members then
                members = {}
            end

            -- print("Adding member:", member.name, "as", naming.toCamelCase(member.name))
            -- print("Member", inspect(member, {showCycles = true}))
            -- print(ffi.sizeof(member.type.name or "int"))

            local metadata = {
                -- name = member.name,
                name = naming.toCamelCase(member.name),
                offset = what == "bitfield" and ((member.offset - math.floor(member.offset)) * 8) or member.offset,
                size = member.type.size,
                address = string.format("0x%x", member.offset),
                type = getNativeCType(member.type.what, member.type.unsigned, member.type.size) or
                    -- member.type.name or member.type.what or "unknown",
                    member.type.name or nil,
                fields = fields,
                what = member.what,
                unsigned = member.type.what == "int" and member.type.unsigned or nil,
                is = member.type.what,
                elementType = hasElements and
                    getNativeCType(member.type.element_type.what, member.type.element_type.unsigned,
                                   member.type.element_type.size) or nil,
                elementSize = hasElements and member.type.element_type.size or nil,
                count = hasElements and getElementCount(member.type) or nil
            }
            table.insert(members, metadata)
            -- members[naming.toCamelCase(member.name)] = metadata
        end
    elseif elementType == "enum" then
        -- for member in reflect.typeof(structName):values() do
        --    table.insert(members, {
        --        name = member.name,
        --        value = member.value,
        --        type = "enum",
        --        what = "value",
        --        size = member.type.size,
        --        address = string.format("0x%x", member.value),
        --        alignment = member.type.alignment
        --    })
        -- end
    else
        -- print("Error: " .. structName .. " is not a struct, but a " .. elementType)
    end

    return members
end

---Attempt to read a header file and return a table that contains the struct definition
---@param headerString string
local function struct(headerString)
    ---@type string
    local header = headerString
    -- Read header file
    assert(headerString, "Failed to read header")

    -- Remove all lines that start with #pragma (need to ask Mango, game apparently doesn't like them)
    header = header:gsub("#pragma[^\n]*\n", "")

    -- Compile and load header file
    ffi.cdef(header)

    -- Get struct definition
    local members = getStructMembers(args.struct)
    if not args.debug then
        print("return " .. inspect(members, {showCycles = true}))
    end

    -- print("Size of struct:", ffi.sizeof(args.struct))
end

-- local structFile = luna.file.read("preprocessed/ui_widget_definition.h")
local structFile = luna.file.read(args.header)
assert(structFile, "Failed to read struct file")

struct(structFile)
