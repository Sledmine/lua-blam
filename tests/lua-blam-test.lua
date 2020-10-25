------------------------------------------------------------------------------
-- Testing for the lua blam library
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
        console_out(message) -- CHANGE THIS TO CONSOLE OUT WITH COLORS!
        (message)
    end
end

function OnCommand(command)
    if (command == "ltest") then
        local runner = lu.LuaUnit.new()
        runner:setOutputType("junit", "luablamtestsresults")
        runner:runSuite()
        return false
    end
end

set_callback("command", "OnCommand")

------------------------------------------------------------------------------
-- Functions
------------------------------------------------------------------------------

testFunctions = {}

function testFunctions:setUp()
    self.bipedTagPath = "characters\\cyborg_mp\\cyborg_mp"
end

function testFunctions:testget_tagIdCompat35()
    ---@type blam35
    local blam35 = blam.compat35()
    local tagId = get_tag_id(blam.tagClasses.biped, self.bipedTagPath)
    lu.assertNotIsNil(tagId, "Tag ID must not be nil")
end

function testFunctions:testget_tagPathCompat35()
    ---@type blam35
    local blam35 = blam.compat35()
    local tagId = get_tag_id(blam.tagClasses.biped, self.bipedTagPath)
    local tagPath = get_tag_path(tagId)
    lu.assertEquals(tagPath, self.bipedTagPath, "Tag path must be " .. self.bipedTagPath)
end

function testFunctions:testget_tagTypeCompat35()
    ---@type blam35
    local blam35 = blam.compat35()
    local tagId = get_tag_id(blam.tagClasses.biped, self.bipedTagPath)
    local tagType = get_tag_type(tagId)
    lu.assertEquals(tagType, "bipd", "Tag type must be bipd")
end

------------------------------------------------------------------------------
-- Blam Objects Test Setup
------------------------------------------------------------------------------

testObjects = {}

function testObjects:setUp()
    self.bipedTagPath = "characters\\cyborg_mp\\cyborg_mp"
    self.uiDefaultProfilesTagPath = "ui\\ui_default_profiles"
    self.defaultProfilesTagList = {
        3909224332,
        3909289869,
        3909355406,
        3909420943,
    }
end

------------------------------------------------------------------------------
-- Tag Objects
------------------------------------------------------------------------------

function testObjects:testTag()
    local cyborgMpTag = blam.getTag(self.bipedTagPath, blam.tagClasses.biped)
    lu.assertNotIsNil(cyborgMpTag, "Cyborg tag must not be nil")
    local bipedTagAddress = get_tag(blam.tagClasses.biped, self.bipedTagPath)
    lu.assertNotIsNil(cyborgMpTag.id, "Cyborg tag id must not be nil")
    lu.assertEquals(cyborgMpTag.address, bipedTagAddress, "Cyborg tag address must match")
    lu.assertEquals(cyborgMpTag.path, self.bipedTagPath, "Cyborg tag path must match")
    lu.assertEquals(cyborgMpTag.class, "bipd", "Cyborg tag class type must be bipd")
end

function testObjects:testTagCollection()
    local uiDefaultProfiles = blam.tagCollection(self.uiDefaultProfilesTagPath)
    lu.assertNotIsNil(uiDefaultProfiles, "Tag collection must not be nil")
    lu.assertEquals(uiDefaultProfiles.count, 4, "Tag collection count must be 4")
    lu.assertEquals(uiDefaultProfiles.tagList, self.defaultProfilesTagList,
                    "Tag collection list must match")
end

function testObjects:testTagCollectionCompat35()
    ---@type blam35
    local blam35 = blam.compat35()
    local uiDefaultProfiles = blam35.tagCollection(
                                  get_tag(blam.tagClasses.tagCollection,
                                          self.uiDefaultProfilesTagPath))
    lu.assertEquals(uiDefaultProfiles.count, 4, "Tag collection count must be 4")
    lu.assertEquals(uiDefaultProfiles.tagList, self.defaultProfilesTagList,
                    "Tag collection list must match")
end

------------------------------------------------------------------------------
-- Game Objects
------------------------------------------------------------------------------

function testObjects:testBipedObject()
    ---@type biped
    local bipedObject = blam.biped(get_dynamic_player())
    lu.assertNotIsNil(bipedObject)
    lu.assertNotIsNil(bipedObject.structure)
    lu.assertEquals(bipedObject.invisible, false)
    lu.assertEquals(bipedObject.shield, 1)
    lu.assertEquals(bipedObject.health, 1)
end

-- Mocked arguments and executions for standalone execution and in game execution
if (not arg) then
    arg = {"-v"}
    -- bprint = print
    print = blam.consoleOutput
end
