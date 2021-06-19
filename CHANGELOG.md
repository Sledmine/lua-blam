# Changelog

# 1.3.0
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

-- NOTE: For some reason the game handles multiplayer info as an static array of one index
```
**Warning:** Like almost every tag reference on lua-blam it only considers tag id reference,
attempting to replace these properties this with a different tag type can result in game crashes,
also the property is a list/array by default due to how the game expects that globals data.

# 1.2.0
- Added `vehicleObjectId` property to `object` structure
- Added `bumpedObjectId` property to `biped` structure
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