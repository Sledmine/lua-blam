# LuaBlam 2.0 - Development Branch

### What is LuaBlam?
Is a Lua library for scripting that allows you to handle data of the game objects in memory of Halo Custom Edition.

### What i can do with it?
Manipulate objects data as scripting table/object properties.

Supported game objects and properties in this version:

| Command | Description |
| --- | --- |
| `git status` | List all *new or modified* files |
| `git diff` | Show file differences that **haven't been** staged |

| Property Name | Description | Takes | Returns |
| ------------- | ------------- | ------------- | ------------- |
| tagId | Index ID of the tag that the object is loading. | DWORD | Number |
| collision | If there is collision for the object or not | Boolean / 1-0 | Boolean |
| isOnGround | If the object is in contact with the BSP | Nothing | Boolean |
| ignoreGravity | Object will be available to stay in air | Boolean / 1-0 | Boolean |
| isOutSideMap | If an object gets out of the BSP | Nothing | Boolean |
| collideable | If other objects can pass through the object (the collision still present for bullets and stuff) | Boolean / 1-0 | Boolean |

### Install LuaBlam
You can download "luablam.lua" library of this repository and move it in to "Halo Custom Edition\Lua".
Is really recommended to install it using "Mercury - Package Manager" check more info about it in this GitHub repository.

### Implementing LuaBlam
You can implement luablam in your script by just adding this line:
```lua
local blam = require("luablam")
```

Here is an example of how you can get and set data of an object, this example shows how to make the current player biped invisible.
```lua
-- Blam script example for Chimera - 572/582 Lua scripting.

local blam = require("luablam") -- Imported from Lua folder.

clua_version = 2.042 -- Set API version.

set_callback("command", "onCommand") -- Register callback, run function "onCommand" when triggered.

function onCommand(command)
    if (command == "invi") then -- If we want to get or unget invisible then...

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

