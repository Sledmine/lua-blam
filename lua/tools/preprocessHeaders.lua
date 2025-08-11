package.path = package.path .. ";lua/?.lua;lua/modules/?.lua;?.lua"
local fs = require "fs"
local inspect = require "inspect"
local luna = require "luna"
local ffi = require "ffi"
local headersDirectory = arg[1] or "src/impl/tag/definitions/"
if not headersDirectory:endswith "/" then
    headersDirectory = headersDirectory .. "/"
end
local includeDirectories =  {
    "src/"
}

print("Preprocessing headers in " .. headersDirectory)

local headers = {}
local forcedIncludes = {}

--- Helper function to run git commands
--- @param command string
--- @return string?
local function git(command)
    local cmd = io.popen("cd " .. headersDirectory .. " && git " .. command)
    assert(cmd, "Failed to open pipe to git " .. command)
    local output = cmd:read("*a")
    cmd:close()
    if output == "" then
        return nil
    end
    if output then
        output = output:trim()
    end
    return output
end

fs.mkdir("preprocessed")

for _, entry in fs.dir(headersDirectory) do
    if entry:name():match("%.h$") then
        print("Processing header: " .. entry:name())
        -- We need to force include some headers to get the proper preprocessed output
        -- This is a forced measure so we don't have to parse the headers to get the proper includes
        local forcedIncludes = table.copy(forcedIncludes)

        local headerFileName = entry:name()
        if table.flip(ignoredHeaders or {})[headerFileName] then
            goto continue
        end

        local structPath = headersDirectory .. headerFileName

        -- We want to preprocess the header so LuaJIT can compile it at runtime later
        -- NOTE: LuaJIT does not preprocess headers, so we have to do it ourselves
        local preprocessCmd = "cpp -E -P -x c " .. structPath
        for _, includeDirectory in ipairs(includeDirectories) do
            preprocessCmd = preprocessCmd .. " -I" .. includeDirectory .. " \\\n"
        end
        for _, forcedInclude in ipairs(forcedIncludes) do
            preprocessCmd = preprocessCmd .. " -include " .. forcedInclude .. " \\\n"
        end

        -- Get the preprocessed header output from the command
        print("Preprocessing " .. headerFileName)
        local cmd = io.popen(preprocessCmd)
        assert(cmd, "Failed to open pipe to " .. preprocessCmd)
        local preprocessedHeader = cmd:read("*a")
        cmd:close()
        --local preprocessedHeader = glue.readpipe(preprocessCmd, "t") --[[@as string]]

        -- Clean up some empty blocks like unused #defines
        preprocessedHeader = preprocessedHeader:gsub("{\n}", "")
        preprocessedHeader = preprocessedHeader:replace("\n         ", "\n")
        -- Remove static asserts "_Static_assert" as they are not needed in LuaJIT
        preprocessedHeader = preprocessedHeader:gsub("_Static_assert%s*%b()", "")
        --print(preprocessedHeader)

        --ffi.cdef(preprocessedHeader)
        -- Test if the preprocessed header can be compiled by LuaJIT
        local testScript = "require \"ffi\".cdef([[" .. preprocessedHeader .. "]])"
        luna.file.write("/tmp/test.lua", testScript)
        if not os.execute("luajit /tmp/test.lua") then
            print("Error: Failed to compile preprocessed header: " .. headerFileName)
            os.exit(1)
        end

        luna.file.write("preprocessed/" .. headerFileName, preprocessedHeader)

        -- Save preprocessed header in our headers table
        if preprocessedHeader and preprocessedHeader ~= "" then
            headers[headerFileName] = preprocessedHeader
        end
        ::continue::
    end
end
