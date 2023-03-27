# Changelog

# 1.7.0
- Added color properties for objects that allow changing from A -> D with lower and upper variants
- Add requests implementation for client and server side
- Add more SAPP bindings

# 1.6.0
- Improved annotations (add better autocompletion, new variables, etc)
- Added new SAPP bindings
- Fixed some functions return
- Added `isApparentlyDead` and `isSilentlyKilled` properties to `blamObject` structure

# 1.5.1
- Minor fixes

# 1.5.0
- Added `findTag` and `findTagsList` functions to search tags using a keyword or partial tag path

Example:
```lua
-- Returns first Tag found matching keyworkd in the tag path, if no tag was found
local assaultRifle = blam.findTag("assault", blam.tagClasses.weapon)
--- assaultRifle.id
--- assaultRifle.path
--- assaultRifle.class
--- assaultRifle.index
--- assaultRifle.indexed

-- Returns a Tag list of multiple matching keywords, nil if no tags found
local weapons = blam.findTagsList("weapons\\", blam.tagClasses.weapon)
for _, weaponTag in pairs(weapons) do
    --- weaponTag.id
    --- weaponTag.path
    --- weaponTag.class
    --- weaponTag.index
    --- weaponTag.indexed
end
```
- Fixed wrong chimera functions annotations
- Fixed bad count reading on `list` type object properties
- Added `cutsceneFlag` property to `scenario` structure

Example:
```lua
local cutsceneFlag = blam.scenario(0).cutsceneFlags[1]
--- cutsceneFlag.name
--- cutsceneFlag.x
--- cutsceneFlag.y
--- cutsceneFlag.z
--- cutsceneFlag.vX
--- cutsceneFlag.vY
```
- Improved EmmyLua autocompletion, added more Chimera and SAPP functions/bindings
- Added more properties to `uiWidgetDefintion` tag structure

# 1.4.0
- Added `getDeviceGroup` function, similar util function to `getTag` and `getObject` but oriented
to device machines

Example:
```lua
-- Blam uses a on memory table to store data about device machines state changes
-- This function provides an easy way to retrieve data from that table

-- Get device machine object properties
local machine = blam.deviceMachine(get_object(machineAddress))
-- This does not return accurate data on the server side, just in client side
local currentMachinePosition = machine.position
-- Luckily this works on server and client but just for retrieving data, not writing
local desiredMachinePosition = blam.getDeviceGroup(machine.positionGroupIndex)
```
- Added `getObject` function, similar util function to `getTag`

Example:
```lua
-- Helps to keep a unique codebase due to SAPP limitations to only retrieve data by id

-- Get blam object by index
local object = blam.getObject(1)

-- Get blam object by id
local object = blam.getObject(3526457484)
```
- Added few handy functions to get game host mode
```lua
blam.isGameHost()
blam.isGameSinglePlayer()
blam.isGameDedicated()
blam.isGameSAPP()
```
- Added `hudGlobals` tag structure, returns data from hud globals tags

Example:
```lua
local hudGlobals = blam.hudGlobals(3464573488)
-- hudGlobals.anchor
-- hudGlobals.x
-- hudGlobals.y
-- hudGlobals.width
-- hudGlobals.height
-- hudGlobals.upTime
-- hudGlobals.fadeTime
-- hudGlobals.iconColorA
-- hudGlobals.iconColorR
-- hudGlobals.iconColorG
-- hudGlobals.iconColorB
-- hudGlobals.textSpacing
```
- Added `deviceMachine` object structure, returns data from machine objects

Example:
```lua
local machine = blam.deviceMachine(get_object(machineAddress))
-- machine.powerGroupIndex
-- machine.power
-- machine.powerChange
-- machine.positonGroupIndex 
-- machine.position
-- machine.positionChange
```
- Added `bipedTag` structure, returns data from biped tags

Example:
```lua
local cyborgBipedTag = blam.bipedTag(34574363363)
-- cyborgBipedTag.disableCollision
```
- Moved `mostRecentDamagerPlayer` property to `biped` structure
- Moved `vehicleObjectId` property to `biped` structure
- Fixed wrong class declaration in `firstPersonInterface` annotation
- Added new blam engine general addresses
- Added property `isCollideable` and `hasNoCollision` to `object` structure
- Added `bipedTag` structure, returns data from a biped tag
- Fixed missing return annotation in property `spawnLocationList` for `scenario` structure
- Added `nameIndex` property to `object` structure
- Added `objectNamesCount` property to `scenario` structure
- Added `objectNames` property to `scenario` structure
Example:
```lua
local scenario = blam.scenario()
console_out(scenario.objectNames[1]) -- "covenant_box"
```

# 1.3.0
- Fixed jump structure intepretation on property `sequences` on `bitmap` structure
- Fixed return annotation for property `sequences` on `bitmap` structure
- Added `walkingState` property to `biped` structure
- Added `motionState` property to `biped` structure
- Added `kills` property to `player` structure
- Fixed a missing return annotation to function `blam.player`
- Added `firstPerson` object structure, returns data from player first person elements

Example:
```lua
-- Get first person object
local firstPerson = blam.firstPerson()
-- firstPerson.weaponObjectId
```

- Added `weapon` object structure, returns data from weapon objects

Example:
```lua
-- Get weapon object data
local weapon = blam.weapon(get_object(weaponObjectAddress))
-- weapon.isWeaponPunching
-- weapon.pressedReloadKey
```

- Added `getJoystickInput` method, returns input data from the joystick attached to to the
game

Example:
```lua
-- Get button 1 input from the controller
local button1 = blam.getJoystickInput(blam.joystickInputs.button1)
if (button1) then
    console_out("Button 1 is being pressed!")
end
```

- Added `globalsTag` structure, it returns some data from the globals tag from the map

Example:
```lua
-- Looks for "globals\\globals" by default if there is no tag path or tag id
local globals = blam.globalsTag()
-- globals.multiplayerInformation[1].flag
-- globals.multiplayerInformation[1].unit
-- globals.firstPersonInterface[1].firstPersonHands

-- NOTE: For some reason the game handles multiplayer info and first person interface as an static array of one index
-- That's why we need to access the first element in the list to interact with the data
```
**Warning:** Like almost every tag reference on lua-blam it only considers tag id reference,
attempting to replace these properties this with a different tag type can result in game crashes,
also the property is a list/array by default due to how the game expects that globals data.

# 1.2.0
- Added `vehicleObjectId` property to `object` structure
- Added 
- Added `vehicleSeatIndex` property to `biped` structure
- Added `player` structure, it returns data from the players table entry

Example
```lua
local playerData = blam.player(get_object())
-- playerData.id
-- playerData.host
-- playerData.name
-- playerData.team
-- playerData.objectId
-- playerData.color
-- playerData.speed
-- playerData.ping
```
- Updated description for `landing` property on `biped` structure
- Updated descriptions for `model` structure
- Deprecated and renamed property from `frozen` to `isFrozen` on `object` structure, still compatible under `frozen` name until next major relase, autocompletion will recommend `isFrozen` hereinafter

# 1.1.0
- Fixed a problem with autocompletion for the `weaponHudInterface` structure
- Added `x` and `y` properties to `weaponHudInterface` structure
- Added `landing` property to `biped` structure

# 1.0.0
- Initial release