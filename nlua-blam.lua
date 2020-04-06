------------------------------------------------------------------------------
-- Blam library for Chimera/SAPP Lua scripting.
-- Authors: Sledmine
-- Version: 4.0
-- Improves memory handle and provides standard functions for scripting
------------------------------------------------------------------------------

local luablam = {}

local operations = {
    bit = {read_bit, write_bit}
    byte = {read_byte, write_byte},
    short = {read_short, write_short},
    word = {read_word, write_word},
    int = {read_int, write_int},
    dword = {read_dword, write_dword}
}

-- Convert bits into boolean values
-- Writing true or false is equal to 1 or 0 but not when reading
local function bit2bool(bit)
    if (bit == 1) then
        return true
    end
    return false
end

metatable = {
    __newindex = function(object, property, value)
        console_out('WRITING data...')
        local propertyData = object.structure[property]
        if (propertyData) then
            local bitLevel = propertyData.bitLevel
            local operation = operations[propertyData.type]
            if (bitLevel) then
                operation.write(object.address + propertyData.offset, bitLevel, value)
            else
                operation.write(object.address + propertyData.offset, value)
            end
        end
    end,
    __index = function(object, property, value)
        console_out('READING data...')
        local propertyData = table.structure[property]
        if (propertyData) then
            local operation = operations[propertyData.type]
            local bitLevel = propertyData.bitLevel
            if (bitLevel) then
                return bit2bool(operation.read(object.address + propertyData.offset, bitLevel))
            else
                return operation.read(object.address + propertyData.offset)
            end
        end
    end
}

-- Biped structure
local bipedStructure = {
    invisible = {type = 'bit', offset = 0x204, bitLevel = 4},
    noDropItems = {type = 'bit', offset = 0x204, bitlevel = 20},
    flashlight = {type = 'bit', offset = 0x204, bitLevel = 19}
    --[[weapons = {
        {jump = 0x64},
        {type = 'byte', offset = 0x378, property = 'name'},
        {type = 'int', offset = 0x867, property = 'damage'}
    }]]
}

-- Remove unused properties for game execution
function cleanObject(t)
    for k,v in pairs(t) do
        if (k ~= 'address' and k ~= 'structure') then
            t[k] = nil
        end
    end
end

local bipedClass = {}
function bipedClass.create(address)
    -- Create object "instance"
    local biped = {}
    -- Legacy values
    biped.address = address
    biped.structure = bipedStructure
    -- Mockup object properties for IDE
    biped.invisible = false
    biped.noDropItems = false
    biped.flashlight = false
    return biped
end

function luablam.biped(address)
    if (address and address ~= 0) then
        local newBiped = bipedClass.create(address)
        setmetatable(newBiped, metatable)
        cleanObject(newBiped)
        return newBiped
    end
    return nil
end

return luablam
