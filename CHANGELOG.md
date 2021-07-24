# Changelog

# 1.3.0
- Added `walkingState` property to `biped` structure
- Added `motionState` property to `biped` structure

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