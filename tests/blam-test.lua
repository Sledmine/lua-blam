---@diagnostic disable: need-check-nil
------------------------------------------------------------------------------
-- Testing for the lua blam library
-- Sledmine, JerryBrick
-- This script must run with no issues in stock bloodgulch
-- (bloodgulch.map) MD5: a044682640d90810a5c45afbbbb011ce 
------------------------------------------------------------------------------
clua_version = 2.056

local lu = require "luaunit"
local blam = require "blam"
local glue = require "glue"
local inspect = require "inspect"

function OnCommand(command)
    if command == "lua_blam_test" then
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

testTagBindedTables = {}

function testTagBindedTables:setUp()
    self.bipedTagPath = "characters\\cyborg_mp\\cyborg_mp"
    self.uiDefaultProfilesTagPath = "ui\\ui_default_profiles"
    self.assaultRifleWphiTagPath = "weapons\\assault rifle\\assault rifle"
    self.assaultRifleFpAnimsTagPath = "weapons\\assault rifle\\fp\\fp"
    self.assaultRifleFpAnimsValues = {1, 6, 255, 4, 5, 2, 2, 9, 9, 255, 8, 7, 255, 3, 255, 255, 12}
    self.defaultProfilesTagList = {3909224332, 3909289869, 3909355406, 3909420943}
    self.multiplayerFlag = 3897165526
    self.multiplayerUnit = 3792109715
    self.firstPersonHands = 3905095503
end

function testTagBindedTables:testScenarioTag()
    local scenario = blam.scenario()
    lu.assertNotIsNil(scenario, "Scenario tag must not be nil")
    lu.assertEquals(scenario.objectNamesCount, 0)
    lu.assertEquals(scenario.objectNames, {})
    lu.assertEquals(scenario.cutsceneFlagsCount, 0)
    lu.assertEquals(scenario.cutsceneFlags, {})
end

function testTagBindedTables:testTag()
    local cyborgMpTag = blam.getTag(self.bipedTagPath, blam.tagClasses.biped)
    lu.assertNotIsNil(cyborgMpTag, "Cyborg tag must not be nil")
    local bipedTagAddress = get_tag(blam.tagClasses.biped, self.bipedTagPath)
    lu.assertNotIsNil(cyborgMpTag.id, "Cyborg tag id must not be nil")
    ---@diagnostic disable-next-line: undefined-field
    lu.assertEquals(cyborgMpTag.address, bipedTagAddress, "Cyborg tag address must match")
    lu.assertEquals(cyborgMpTag.path, self.bipedTagPath, "Cyborg tag path must match")
    lu.assertEquals(cyborgMpTag.class, "bipd", "Cyborg tag class type must be bipd")
end

function testTagBindedTables:testTagCollection()
    local uiDefaultProfiles = blam.tagCollection(self.uiDefaultProfilesTagPath)
    lu.assertNotIsNil(uiDefaultProfiles, "Tag collection must not be nil")
    lu.assertEquals(uiDefaultProfiles.count, 4, "Tag collection count must be 4")
    lu.assertEquals(uiDefaultProfiles.tagList, self.defaultProfilesTagList,
                    "Tag collection list must match")
end

function testTagBindedTables:testModelAnimations()
    local assaultRifleAnimations = blam.modelAnimations(self.assaultRifleFpAnimsTagPath)
    lu.assertEquals(assaultRifleAnimations.fpAnimationList, self.assaultRifleFpAnimsValues)
end

function testTagBindedTables:testWeaponHudInterface()
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

function testTagBindedTables:testGlobalsTag()
    local globals = blam.globalsTag()
    lu.assertNotIsNil(globals, "Globals should must not be nil")
    lu.assertIsTrue(#globals.multiplayerInformation > 0, "Globals must have multiplayer information")
    lu.assertEquals(globals.multiplayerInformation[1].flag, self.multiplayerFlag)
    lu.assertEquals(globals.multiplayerInformation[1].unit, self.multiplayerUnit)
    lu.assertEquals(globals.firstPersonInterface[1].firstPersonHands, self.firstPersonHands)
end

function testTagBindedTables:testHudGlobalsTag()
    local hudGlobals = blam.hudGlobals([[ui\hud\default]])
    lu.assertNotIsNil(hudGlobals, "HUD Globals should must not be nil")
    lu.assertEquals(hudGlobals.anchor, 0)
    lu.assertEquals(hudGlobals.x, 0)
    lu.assertEquals(hudGlobals.y, 60)
    lu.assertEquals(hudGlobals.width, 0)
    lu.assertEquals(hudGlobals.height, 0)
    lu.assertEquals(hudGlobals.upTime, 2)
    lu.assertEquals(hudGlobals.fadeTime, 2)
    lu.assertEquals(hudGlobals.iconColorA, 0.5)
    lu.assertAlmostEquals(hudGlobals.iconColorR, 0.458824, 0.000001)
    lu.assertAlmostEquals(hudGlobals.iconColorG, 0.729412, 0.000001)
    lu.assertEquals(hudGlobals.textColorB, 1)
    lu.assertEquals(hudGlobals.textColorA, 0.5)
    lu.assertAlmostEquals(hudGlobals.textColorR, 0.458824, 0.000001)
    lu.assertAlmostEquals(hudGlobals.textColorG, 0.729412, 0.000001)
    lu.assertEquals(hudGlobals.textColorB, 1)
    lu.assertAlmostEquals(hudGlobals.textSpacing, 1.35, 0.000001)
end

function testTagBindedTables:testUnicodeStringsTag()
    local unicodeStrings = blam.unicodeStringList([[ui\random_player_names]])
    lu.assertNotIsNil(unicodeStrings, "Unicode strings should must not be nil")
    lu.assertNotIsFalse(unicodeStrings.count > 0, "Unicode strings count must be greater than 0")
    lu.assertEquals(unicodeStrings.strings[1], "Sleepy")
    lu.assertEquals(unicodeStrings.strings[2], "Dopey")
    lu.assertEquals(unicodeStrings.strings[3], "Grumpy")
    local newStrings = {"Sloopy", "Loopy", "Boopy"}
    unicodeStrings.strings = newStrings
    lu.assertEquals(unicodeStrings.strings[1], "Sloopy")
    lu.assertEquals(unicodeStrings.strings[2], "Loopy")
    lu.assertEquals(unicodeStrings.strings[3], "Boopy")
    newStrings = {"Sleepy", "Dopey", "Grumpy"}
    unicodeStrings.strings = newStrings
end

------------------------------------------------------------------------------
-- Game Objects
------------------------------------------------------------------------------
testObjects = {}

function testObjects:setUp()
    self.assaultRifleTagPath = "weapons\\assault rifle\\assault rifle"
end

function testObjects:testGetObject()
    local player = blam.player(get_player())
    if (player) then
        local playerBiped = blam.biped(get_object(player.objectId))
        local bipedObjectFromObjectId = blam.getObject(player.objectId)
        lu.assertEquals(playerBiped.address, bipedObjectFromObjectId.address,
                        "Address from biped object must match address from object id")

        local objectIndex = blam.getIndexById(player.objectId)
        local bipedObjectFromObjectIndex = blam.getObject(objectIndex)
        lu.assertEquals(playerBiped.address, bipedObjectFromObjectIndex.address,
                        "Address from biped object must match address from object index")
    end
end

function testObjects:testBipedObject()
    local bipedObject = blam.biped(get_dynamic_player()) --[[@as biped]]
    lu.assertNotIsNil(bipedObject)
    ---@diagnostic disable-next-line: undefined-field
    lu.assertNotIsNil(bipedObject.structure)
    lu.assertEquals(bipedObject.invisible, false, "Biped should not have camouflage active")
    lu.assertEquals(bipedObject.shield, 1, "Biped shield should not depleted")
    lu.assertEquals(bipedObject.health, 1, "Biped health should not depleted")
    lu.assertEquals(bipedObject.isNotDamageable, false, "Biped should be damageable")
    lu.assertEquals(bipedObject.bumpedObjectId, 0, "Biped should not be bumping other objects")
    if (blam.isNull(bipedObject.vehicleObjectId)) then
        lu.assertIsTrue(blam.isNull(bipedObject.vehicleObjectId),
                        "Biped should not be inside a vehicle")
        lu.assertIsTrue(blam.isNull(bipedObject.vehicleSeatIndex),
                        "Biped should not be seated on a vehicle")
    else
        lu.assertIsTrue(not blam.isNull(bipedObject.vehicleObjectId), "Biped is inside a vehicle")
        lu.assertEquals(bipedObject.vehicleSeatIndex, 0, "Biped is seated on seat index 0")
    end
    lu.assertIsTrue(blam.isNull(bipedObject.landing), "Biped should not be landing")
    lu.assertEquals(bipedObject.walkingState, 0, "Biped should not be walking")
    lu.assertEquals(bipedObject.motionState, 0, "Biped should not be in motion")
    lu.assertIsTrue(blam.isNull(bipedObject.nameIndex), "Biped should not have a name list index")
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
    lu.assertEquals(get_object(player.objectId), get_dynamic_player(),
                    "Player object id address should match address from player object")
    lu.assertNotIsNil(player.color, "Player color must not be nil")
    lu.assertEquals(player.index, 0, "Player index should be 0")
    lu.assertEquals(player.speed, 1, "Player speed should be 1")
    lu.assertIsTrue((player.ping >= 0), "Player ping should be greater than 0 or equal 0")
    lu.assertEquals(player.kills, 0, "Player kills should be 0")
    lu.assertEquals(player.assists, 0, "Player assists should be 0")
    lu.assertEquals(player.betraysAndSuicides, 0, "Player betrays and suicides should be 0")
    lu.assertEquals(player.deaths, 0, "Player deaths should be 0")
    lu.assertEquals(player.suicides, 0, "Player suicides should be 0")
end

------------------------------------------------------------------------------
-- Module utilities
------------------------------------------------------------------------------
testUtilities = {}

function testUtilities:testRotationFunctions()
    -- local yaw, roll, matrix = eulerToRotation(90, 180)
    -- lu.assertAlmostEquals(yaw, {x = 0.707, y = 0.707, z = 0})
end

testGameState = {}

function testGameState:testCinematicGlobals()
    execute_script("cinematic_stop")
    local cinematic = blam.cinematicGlobals()
    lu.assertNotIsNil(cinematic, "Cinematic globals must not be nil")
    lu.assertIsFalse(cinematic.isInProgress, "Cinematic should not be in progress")
    lu.assertIsFalse(cinematic.isShowingLetterbox, "Cinematic should not be showing letterbox")
    execute_script("cinematic_start")
    lu.assertIsTrue(cinematic.isInProgress, "Cinematic should be in progress")
    lu.assertIsTrue(cinematic.isShowingLetterbox, "Cinematic should be showing letterbox")
    execute_script("cinematic_stop")
    lu.assertIsFalse(cinematic.isInProgress, "Cinematic should not be in progress")
    lu.assertIsFalse(cinematic.isShowingLetterbox, "Cinematic should not be showing letterbox")
end

-- Mocked arguments and executions for standalone execution and in game execution
if not arg then
    arg = {"-v"}
    -- bprint = print
    print = function(message)
        if message:find("Failure", 1, true) then
            blam.consoleOutput(message, table.unpack(blam.consoleColors.error))
            return
        elseif message:find("Starting", 1, true) then
            blam.consoleOutput(message, table.unpack(blam.consoleColors.unknown))
            return
        elseif message:find("0 failure", 1, true) then
            blam.consoleOutput(message, table.unpack(blam.consoleColors.success))
            return
        elseif message:find("[1-9]+ failure") then
            blam.consoleOutput(message, table.unpack(blam.consoleColors.warning))
            return
        end
        blam.consoleOutput(message)
    end
end
