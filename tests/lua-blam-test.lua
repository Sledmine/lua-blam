------------------------------------------------------------------------------
-- Testing for the lua-blam library
-- Sledmine, JerryBrick
-- This script must run perfectly in stock Bloodgulch!!
------------------------------------------------------------------------------
clua_version = 2.042

local lu = require "luaunit"
local blam = require "nlua-blam"
local glue = require "glue"
local inspect = require "inspect"

-- Mocked function to redirect print calls to test print
local function tprint(message, ...)
    if (message) then
        message = tostring(message)
        if (message:find("Starting")) then
            console_out(message) -- CHANGE THIS TO CONSOLE OUT WITH COLORS!
            return
        end
        console_out(message)
    end
end

function OnCommand(command)
    if (command == "ltest") then
        local runner = lu.LuaUnit.new()
        runner:setOutputType("junit", "luablam_tests_results")
        runner:runSuite()
        return false
    end
end

set_callback("command", "OnCommand")

test_Objects = {}

function test_Objects:setUp()
    self.bipedTagPath = "characters\\cyborg_mp\\cyborg_mp"
end

function test_Objects:test_Tag_Object()
    ---@type tagClass
    local bipedTagObject = blam.getTag(self.bipedTagPath, blam.tagClasses.biped)
    lu.assertNotIsNil(bipedTagObject)
    local bipedTagAddress = get_tag(blam.tagClasses.biped, self.bipedTagPath)
    lu.assertEquals(bipedTagObject.address, bipedTagAddress)
    lu.assertEquals(bipedTagObject.path, self.bipedTagPath)
    lu.assertEquals(bipedTagObject.class, "bipd")
end

function test_Objects:test_Biped_Object()
    ---@type bipedClass
    local bipedObject = blam.biped(get_dynamic_player())
    lu.assertNotIsNil(bipedObject)
    lu.assertNotIsNil(bipedObject.structure)
    lu.assertEquals(bipedObject.invisible, true)
end


-- Mocked arguments and executions for standalone execution and in game execution
if (not arg) then
    arg = {"-v"}
    -- bprint = print
    print = blam.consoleOutput
end
