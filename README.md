# LuaBlam 1.0 

### What is LuaBlam?
Is a Lua library for scripting that allows you to handle data of the game objects in memory of Halo Custom Edition.

### What i can do with it?
Manipulate objects data as scripting table/object properties.

Supported game objects and properties in this version:
- Biped:
    - Tag ID
    - Health, Shield
    - X, Y, Z
    - xVel, yVel, zVel
    - Yaw, Pitch
    - Animation, Animation Timer
    - Crouch
    - Weapon Slot
    - Flashlight
    - Invisible
    - Current Nade, Frag Grenades, Plasma Grenades
    - Zoom Level
    - Current Weapon
    - Region Permutation 1, 2

### Install LuaBlam
You can download "luablam.lua" library of this repository and move it in to "Halo Custom Edition\Lua".
Is really recommended to install it using "Mercury - Package Manager" check more info about it in this GitHub repository.

### Implementing LuaBlam
You can implement luablam in your script by just adding this line:
```lua
local blam = require("luablam")
```

Here is an example of how you can get and set data of and object, this example shows how to make the current player invisible.
```lua

-- Blam text example for Chimera - 572/582 Lua scripting.

local blam = require("luablam") -- Imported from Lua folder.

clua_version = 2.042 -- Set API version.

set_callback("command", "onCommand") -- Register callback, run function "onCommand" when triggered.

function onCommand(command)
    if (command == "invi") then -- If we wan to get or unget invisible then...

        local playerAddress = get_dynamic_player() -- Get current player memory address.

        if (playerAddress ~= nil) then -- There are no errors getting player address then...

            -- Get biped data of the specified object address (giving current player address).
            local playerBiped = blam.biped(playerAddress)

            if (playerBiped ~= nil) then -- If there are no errors getting player biped data then...
                
                -- Save player invisible property into "playerIsInvisible" variable
                playerIsInvisible = playerBiped.invisible

                -- Refresh biped data info giving table/object with invisible property with "not" operator to invert value
                blam.biped(playerAddress, { invisible = not(playerIsInvisible) })

            end
        end
        return false
    end
end
```
### Before "invi" command
![Before "invi" command](https://i.imgur.com/W8Vyw0F.png)

### After "invi" command
![After "invi" command](https://i.imgur.com/oENJ4xG.png)

