------------------------------------------------------------------------------
-- Testing for the lua blam library
-- Sledmine, JerryBrick
-- This script must run perfectly in stock Bloodgulch!!
------------------------------------------------------------------------------
clua_version = 2.042

local lu = require "luaunit"
local blam = require "blam"
local glue = require "glue"
local inspect = require "inspect"

-- Mocked function to redirect print calls to test print
local function tprint(message, ...)
    if (message) then
        message = tostring(message)
        if (message:find("Starting")) then
            console_out(message)
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

------------------------------------------------------------------------------
-- Functions
------------------------------------------------------------------------------

testFunctions = {}

------------------------------------------------------------------------------
-- Blam Objects Test Setup
------------------------------------------------------------------------------

testObjects = {}

function testObjects:setUp()
    self.bipedTagPath = "characters\\cyborg_mp\\cyborg_mp"
    self.uiDefaultProfilesTagPath = "ui\\ui_default_profiles"
    self.assaultRifleWphiTagPath = "weapons\\assault rifle\\assault rifle"
    self.assaultRifleFpAnimsTagPath = "weapons\\assault rifle\\fp\\fp"
    self.assaultRifleFpAnimsValues = {1, 6, 255, 4, 5, 2, 2, 9, 9, 255, 8, 7, 255, 3, 255, 255, 12}
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

function testObjects:testModelAnimations()
    local assaultRifleAnimations = blam.modelAnimations(self.assaultRifleFpAnimsTagPath)
    lu.assertEquals(assaultRifleAnimations.fpAnimationList, self.assaultRifleFpAnimsValues)
end

function testObjects:testWeaponHudInterface()
    local wphi = blam.weaponHudInterface(self.assaultRifleWphiTagPath)
    lu.assertEquals(wphi.childHud, 3800891673)
    lu.assertEquals(wphi.totalAmmoCutOff, 61)
    lu.assertEquals(wphi.loadedAmmoCutOff, 10)
    lu.assertEquals(wphi.heatCutOff, 0)
    lu.assertEquals(wphi.ageCutOff, 0)
    lu.assertNotIsNil(wphi.crosshairs)
    lu.assertEquals(wphi.crosshairs[1].type, 0)
    lu.assertEquals(wphi.crosshairs[1].mapType, 0)
    lu.assertEquals(wphi.crosshairs[1].bitmap, 3801350432)
    lu.assertNotIsNil(wphi.crosshairs[1].overlays)
    lu.assertEquals(wphi.crosshairs[1].overlays[1].x, 0)
    lu.assertEquals(wphi.crosshairs[1].overlays[1].y, 0)
    lu.assertEquals(wphi.crosshairs[1].overlays[1].widthScale, 1)
    lu.assertEquals(wphi.crosshairs[1].overlays[1].heightScale, 1)
    lu.assertEquals(wphi.crosshairs[1].overlays[1].defaultColorA, 0)
    lu.assertEquals(wphi.crosshairs[1].overlays[1].defaultColorR, 40)
    lu.assertEquals(wphi.crosshairs[1].overlays[1].defaultColorG, 150)
    lu.assertEquals(wphi.crosshairs[1].overlays[1].defaultColorB, 255)
    lu.assertEquals(wphi.crosshairs[1].overlays[1].sequenceIndex, 0)
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
    lu.assertIsTrue(blam.isNull(bipedObject.landing))
    lu.assertEquals(bipedObject.walkingDirection, 0)
end

-- Mocked arguments and executions for standalone execution and in game execution
if (not arg) then
    arg = {"-v"}
    -- bprint = print
    print = blam.consoleOutput
end
