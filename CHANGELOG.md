# Changelog

## 4.1: Big refactor, new internal structure

Performance and useful refactor

- All the object creation has been refactored into one single function
- Expanded functions have been eliminated (still available with the compatibility layer)
- Added some cross platform bug fixes
- Code format has been moved to follow [lua formatter](https://githubcom/Koihik/LuaFormatter) standards

## 4.0: Internal structure refactoring

All the library has been refactored with better implementations

- There are not more hard coded tag reading implementations or at least just a few
- Objects made with lua-blam now can be used as a bridge to read/write data
- Emmy Lua annotations have been added to help Visual Studio code users
- Added global full name tag classes/types translation to short blam tag types

## 3.5: Added model animations structure type

- Added model animations type (16 = FPWAnimL)

## 3.4: Added sound structure type

- Added sound class type

## 3.3: Added experimental vertices structure

- Added dataReclaimer for collsions vertices (15 = VertexL)

## 3.2: Fixed vehicle list rotation, added new unified API function

- Added binding for "execute_script" function from Chimera to SAPP

## 3.1: Scenario vehicle list is available now

- Object dataReclaimer now supports scenario vehicles list (14 = VehicleL)

## 3.0: Added global compatibility API functions for SAPP and Chimera

- Extra standard functions were added (get_tag_id, get_tag_path)

## 2.1: New tag data handle added, implemented string metable

- Added support for ui widgets definition (UNCOMPLETE, MORE VALUES REQUIRED)
- Added support for weapon hud interfaces (UNSTABLE, HARDCODED TO FIRST CROSSHAIR ELEMENT)
- Added support for unicode string lists
- Added playerIsLookingAt function
- Object dataReclaimer now supports unicode string list (10 = UStringL)
- Object dataReclaimer now supports scenery palette list (11 = SceneryPL) -- Only for reading
- Object dataReclaimer now supports child ui widgets list (12 = ChildWL) -- Only for reading
- Object dataReclaimer now supports player starting locations list (13 = PlayerSLL)

## 2.0: Introducing data reclaimers

Insane optimization, expanded object structures and available properties, better implentation for reading and writing data

    - Introducing "dataReclaimer", this is an array with specific values for structure fields
    - Improved bit2bool convertion now only 1 as bit value is being interpreted as true any other value will be always false

    dataReclaimer is an array with a specific ordered data:

    dataReclaimer[0] -- Memory address to read/write a value
    dataReclaimer[1] -- Specify the type of value to read/write

    0 = Bit
    1 = Byte
    2 = Short
    3 = Word
    4 = Int
    5 = Dword
    6 = Float
    7 = Double
    8 = Char
    9 = String

    In case of reading/writing a bit value we can set a specific bit position sending an extra value in the array:

    dataReclaimer = {0x213, 0, 8}
                                ^
                                |
    This means the position of the bit that we are seeking to read/write

## 1.1: Changes for writable and readable biped properties

## 1.0: First realease for Flood 09, biped handle ready
