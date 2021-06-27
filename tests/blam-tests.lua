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
-- Tag Objects
------------------------------------------------------------------------------

testTagObjects = {}

function testTagObjects:setUp()
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
    self.multiplayerFlag = 3897165526
    self.multiplayerUnit = 3792109715
    self.firstPersonHands = 3905095503
end

function testTagObjects:testTag()
    local cyborgMpTag = blam.getTag(self.bipedTagPath, blam.tagClasses.biped)
    lu.assertNotIsNil(cyborgMpTag, "Cyborg tag must not be nil")
    local bipedTagAddress = get_tag(blam.tagClasses.biped, self.bipedTagPath)
    lu.assertNotIsNil(cyborgMpTag.id, "Cyborg tag id must not be nil")
    lu.assertEquals(cyborgMpTag.address, bipedTagAddress, "Cyborg tag address must match")
    lu.assertEquals(cyborgMpTag.path, self.bipedTagPath, "Cyborg tag path must match")
    lu.assertEquals(cyborgMpTag.class, "bipd", "Cyborg tag class type must be bipd")
end

function testTagObjects:testTagCollection()
    local uiDefaultProfiles = blam.tagCollection(self.uiDefaultProfilesTagPath)
    lu.assertNotIsNil(uiDefaultProfiles, "Tag collection must not be nil")
    lu.assertEquals(uiDefaultProfiles.count, 4, "Tag collection count must be 4")
    lu.assertEquals(uiDefaultProfiles.tagList, self.defaultProfilesTagList,
                    "Tag collection list must match")
end

function testTagObjects:testModelAnimations()
    local assaultRifleAnimations = blam.modelAnimations(self.assaultRifleFpAnimsTagPath)
    lu.assertEquals(assaultRifleAnimations.fpAnimationList, self.assaultRifleFpAnimsValues)
end

function testTagObjects:testWeaponHudInterface()
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

function testTagObjects:testGlobalsTag()
    local globals = blam.globalsTag()
    lu.assertNotIsNil(globals, "Globals should must not be nil")
    lu.assertIsTrue(#globals.multiplayerInformation > 0, "Globals must have multiplayer information")
    lu.assertEquals(globals.multiplayerInformation[1].flag, self.multiplayerFlag)
    lu.assertEquals(globals.multiplayerInformation[1].unit, self.multiplayerUnit)
    lu.assertEquals(globals.firstPersonInterface[1].firstPersonHands, self.firstPersonHands)
end

------------------------------------------------------------------------------
-- Game Objects
------------------------------------------------------------------------------
testObjects = {}

function testObjects:setUp()
    self.assaultRifleTagPath = "weapons\\assault rifle\\assault rifle"
end

function testObjects:testBipedObject()
    local bipedObject = blam.biped(get_dynamic_player())
    lu.assertNotIsNil(bipedObject)
    lu.assertNotIsNil(bipedObject.structure)
    lu.assertEquals(bipedObject.invisible, false, "Biped should not have camouflage active")
    lu.assertEquals(bipedObject.shield, 1, "Biped shield should not depleted")
    lu.assertEquals(bipedObject.health, 1, "Biped health should not depleted")
    lu.assertEquals(bipedObject.isNotDamageable, false, "Biped should be damageable")
    lu.assertEquals(bipedObject.bumpedObjectId, 0, "Biped should not be bumping other objects")
    if (blam.isNull(bipedObject.vehicleObjectId)) then
        lu.assertIsTrue(blam.isNull(bipedObject.vehicleObjectId), "Biped should not be inside a vehicle")
        lu.assertIsTrue(blam.isNull(bipedObject.vehicleSeatIndex), "Biped should not be seated on a vehicle")
    else
        lu.assertIsTrue(not blam.isNull(bipedObject.vehicleObjectId), "Biped is inside a vehicle")
        lu.assertEquals(bipedObject.vehicleSeatIndex, 0, "Biped is seated on seat index 0")
    end
    lu.assertIsTrue(blam.isNull(bipedObject.landing), "Biped should not be landing")
end

function testObjects:testFirstPersonObject()
    local firstPerson = blam.firstPerson()
    lu.assertNotIsNil(firstPerson)
    lu.assertIsTrue(not blam.isNull(firstPerson.weaponObjectId))
    local object = blam.object(get_object(firstPerson.weaponObjectId))
    lu.assertNotIsNil(object)
    local tag = blam.getTag(object.tagId)
    lu.assertNotIsNil(tag)
    local isAnExpectedWeapon
    if (tag.path:find("plasma pistol") or tag.path:find("assault rifle")) then
        isAnExpectedWeapon = true
    end
    lu.assertIsTrue(isAnExpectedWeapon)
end

function testObjects:testWeaponObject()
    local firstPerson = blam.firstPerson()
    lu.assertNotIsNil(firstPerson)
    local weapon = blam.weapon(get_object(firstPerson.weaponObjectId))
    lu.assertNotIsNil(weapon)
    lu.assertIsFalse(weapon.isWeaponPunching)
    lu.assertIsFalse(weapon.pressedReloadKey)
end

------------------------------------------------------------------------------
-- Data Objects
------------------------------------------------------------------------------

function testObjects:testPlayerDataObject()
    local player = blam.player(get_player())
    lu.assertNotIsNil(player, "Player object must not be nil")
    lu.assertNotIsNil(player.id, "Player id must not be nil")
    lu.assertEquals(player.host, 0, "Player should be host")
    local playerName = blam.readUnicodeString(get_player() + 0x4, true)
    lu.assertEquals(player.name, playerName, "Player names should be equal")
    lu.assertEquals(player.team, 0, "Player team should be red")
    lu.assertNotIsNil(player.objectId, "Player objectId mut not be nil")
    lu.assertEquals(get_object(player.objectId), get_dynamic_player(), "Player object id address should match address from player object")
    lu.assertNotIsNil(player.color, 0, "Player color must not be nil")
    lu.assertEquals(player.index, 0, "Player index should be 0")
    lu.assertEquals(player.speed, 1, "Player speed should be 1")
    lu.assertIsTrue((player.ping >= 0), "Player ping should be greater than 0 or equal 0")
end

-- Mocked arguments and executions for standalone execution and in game execution
if (not arg) then
    arg = {"-v"}
    -- bprint = print
    print = blam.consoleOutput
end
