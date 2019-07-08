# LuaBlam 2.0 - Development Branch

### What is LuaBlam?
Is a Lua library for scripting that allows you to handle data of the game objects in memory of Halo Custom Edition.

### What i can do with it?
Manipulate objects data as scripting table/object properties.

# Supported game objects and properties in this version:

### Object Generic
Basically every spawned thing in the game is an object

| Property Name | Description | Takes | Returns |
| ------------- | ------------- | ------------- | ------------- |
| tagId | Index ID of the tag that the object is loading. | DWORD | Number |
| collision | Enable/disable collision geometry of the object | Boolean / 1-0 | Boolean |
| isOnGround | If the object is in contact with the BSP | Nothing | Boolean |
| ignoreGravity | Object will be available to stay in the air | Boolean / 1-0 | Boolean |
| isOutSideMap | If an object gets out of the BSP | Nothing | Boolean |
| collideable | If other objects can pass through the object (the collision still present for bullets and stuff) | Boolean / 1-0 | Boolean |
| health | Amount of health of the object | Float | Number |
| shield | Amount of shield of the object | Float | Number |
| x | Position of the object in X axis | Float | Number |
| y | Position of the object in Y axis | Float | Number |
| z | Position of the object in Z axis | Float | Number |
| xVel | Velocity applied to the object in X axis | Float | Number |
| yVel | Velocity applied to the object in Y axis | Float | Number |
| zVel | Velocity applied to the object in Z axis | Float | Number |
| xScale | Scale in X axis of the object | Float | Number |
| yScale | Scale in Y axis of the object | Float | Number |
| zScale | Scale in Z axis of the object | Float | Number |
| pitch | Object pitch navigation angle | Float | Number |
| yaw | Object yaw navigation angle | Float | Number |
| roll | Object roll navigation angle | Float | Number |
| pitchVel | Velocity applied to the object in pitch | Float | Number |
| yawVel | Velocity applied to the object in yaw | Float | Number |
| rollVel | Velocity applied to the object in roll | Float | Number |
| type | What type of object is being modified:<br>0 = Biped<br>1 = Vehicle<br>2 = Weapon<br>3 = Equipment<br>4 = Garbage<br>5 = Projectile<br>6 = Scenery<br>7 = Machine<br>8 = Control<br>9 = Light Fixture<br>10 = Placeholder<br>11 = Sound Scenery<br>| Nothing | Number |

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

