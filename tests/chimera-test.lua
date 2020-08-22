------------------------------------------------------------------------------
-- Chimera Test
-- Test cases for Chimera API
-- Author: Sledmine, JerryBrick
-- Version: 1.0
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
    if (command == "ctest") then
        local runner = lu.LuaUnit.new()
        runner:setOutputType("junit", "chimera_tests_results")
        runner:runSuite()
        return false
    elseif (command == "cob") then
        for index, objectId in pairs(blam.getObjects()) do
            local tempObject = blam.object(get_object(objectId))
            local objectType = glue.index(blam.objectClasses)[tempObject.type]
            if (objectType == "biped") then
                console_out(objectType .. " " .. objectId)
            end
        end
    end
end

set_callback("command", "OnCommand")

----------------- On Command Tests -----------------------

test_auxiliarFunctions = {}

function test_auxiliarFunctions:test_getDynamicPlayer()
    glue.writefile("chimera_tests.txt", "test_getDynamicPlayer", "t")
    local memoryResult = get_dynamic_player()
    lu.assertNotIsNil(memoryResult)
end

function test_auxiliarFunctions:test_getDynamicPlayer_BlamValue()
    glue.writefile("chimera_tests.txt", "test_getDynamicPlayer_BlamValue", "t")
    local memoryResult = get_dynamic_player()
    local player = blam.biped(memoryResult)
    lu.assertEquals(player.zoomLevel, 255)
end

----------------- Objects Tests -----------------------

test_Objects = {}

function test_Objects:test_Objects_Spawn_And_Delete()
    glue.writefile("chimera_tests.txt", "test_Objects_Spawn_And_Delete", "t")
    local objectResult = false
    local objectId = spawn_object("biped", "characters\\cyborg_mp\\cyborg_mp", 31, -82, 0.061)
    lu.assertNotIsNil(objectId)
    delete_object(objectId)
    --objectAddress = get_object(objectId)
    --local cyborgBiped = blam.biped(objectAddress)
    --lu.assertEquals(cyborgBiped.health, 0)
end


function test_Objects:test_Get_Object_With_Whole_Id()
    glue.writefile("chimera_tests.txt", "test_Get_Object_With_Whole_Id", "t")
    local gameObjects = blam.getObjects()
    lu.assertNotIsNil(gameObjects)
    lu.assertEquals(#gameObjects > 0, true)
end

function test_Objects:test_Get_Object_With_Index()
    
end


-- Mocked arguments and executions for standalone execution and in game execution
if (not arg) then
    arg = {"-v"}
    -- bprint = print
    print = tprint
end
