# LuaBlam 2.1

### What is LuaBlam?
Is a Lua library for scripting that allows you to handle Halo Custom Edition memory as objects.

### What is intended for?
Manipulate game memory as table/object properties.

***
## Installing LuaBlam

You can install LuaBlam into Halo Custom Edition using [Mercury - Package Manager](https://github.com/Sledmine/Mercury).<br>
```
mercury install luablam
```
**WARNING!!!**: LuaBlam package from **Mercury** repository is minified, if you want to look at source code comments and readable sentences you need to use the files from this branch.

Use the line above to download and install it from the **Mercury** repository.

We really recommend you to use **Mercury** to install it, otherwise you can download the "luablam.lua" library from this repository and move it in to "Halo Custom Edition\lua".
***

## Supported game objects and properties:

### Object Generic
> Basically every kind of thing that can be spawned in a map is a **game object**.<br>
**These properties are shared between different types of game objects.**

| Property Name            | Description                                                                                                                                                                                                                                        | Takes         | Returns |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------- |
| tagId                    | Index ID of the tag that the object is loading.                                                                                                                                                                                                    | DWORD         | Number  |
| collision                | Enable/disable collision geometry of the object                                                                                                                                                                                                    | Boolean / 1-0 | Boolean |
| collideable              | If other objects can pass through the object (the collision still present for bullets and stuff)                                                                                                                                                   | Boolean / 1-0 | Boolean |
| ignoreGravity            | Object will be available to stay in the air                                                                                                                                                                                                        | Boolean / 1-0 | Boolean |
| isOnGround               | If the object is in contact with the BSP                                                                                                                                                                                                           | Nothing       | Boolean |
| isOutSideMap             | If an object gets out of the BSP                                                                                                                                                                                                                   | Nothing       | Boolean |
| health                   | Amount of health of the object                                                                                                                                                                                                                     | Float         | Number  |
| shield                   | Amount of shield of the object                                                                                                                                                                                                                     | Float         | Number  |
| x                        | Position of the object in X axis                                                                                                                                                                                                                   | Float         | Number  |
| y                        | Position of the object in Y axis                                                                                                                                                                                                                   | Float         | Number  |
| z                        | Position of the object in Z axis                                                                                                                                                                                                                   | Float         | Number  |
| xVel                     | Velocity applied to the object in X axis                                                                                                                                                                                                           | Float         | Number  |
| yVel                     | Velocity applied to the object in Y axis                                                                                                                                                                                                           | Float         | Number  |
| zVel                     | Velocity applied to the object in Z axis                                                                                                                                                                                                           | Float         | Number  |
| xScale                   | Scale in X axis of the object                                                                                                                                                                                                                      | Float         | Number  |
| yScale                   | Scale in Y axis of the object                                                                                                                                                                                                                      | Float         | Number  |
| zScale                   | Scale in Z axis of the object                                                                                                                                                                                                                      | Float         | Number  |
| pitch                    | Object pitch navigation angle                                                                                                                                                                                                                      | Float         | Number  |
| yaw                      | Object yaw navigation angle                                                                                                                                                                                                                        | Float         | Number  |
| roll                     | Object roll navigation angle                                                                                                                                                                                                                       | Float         | Number  |
| pitchVel                 | Velocity applied to the object in pitch                                                                                                                                                                                                            | Float         | Number  |
| yawVel                   | Velocity applied to the object in yaw                                                                                                                                                                                                              | Float         | Number  |
| rollVel                  | Velocity applied to the object in roll                                                                                                                                                                                                             | Float         | Number  |
| type                     | What type of object is being modified:<br>0 = Biped<br>1 = Vehicle<br>2 = Weapon<br>3 = Equipment<br>4 = Garbage<br>5 = Projectile<br>6 = Scenery<br>7 = Machine<br>8 = Control<br>9 = Light Fixture<br>10 = Placeholder<br>11 = Sound Scenery<br> | Nothing       | Number  |
| animation                | Index of the animation that the object is playing                                                                                                                                                                                                  | WORD          | Number  |
| animationTimer           | Frame of the actual animation of the object                                                                                                                                                                                                        | WORD          | Number  |
| regionPermutation[Index] | Permutation index of the first model region of the object, from 1 to 8.                                                                                                                                                                            | WORD          | Number  |

### Biped
> Bipeds are usually **players**, **enemies**, and RARELY some kind of **vehicles**.

| Property Name  | Description                                                          | Takes         | Returns |
| -------------- | -------------------------------------------------------------------- | ------------- | ------- |
| invisible      | Current invisible state of the biped                                 | Boolean / 1-0 | Boolean |
| noDropItems    | Biped is able to drop his items at dying                             | Boolean / 1-0 | Boolean |
| flashlight     | Current state of biped flashlight                                    | Boolean / 1-0 | Boolean |
| crouchHold     | Player controlling the biped is holding the crouch button            | Nothing       | Boolean |
| jumpHold       | Player controlling the biped is holding the jump button              | Nothing       | Boolean |
| flashlightKey  | Returns true or false if flashlight key was pressed                  | Nothing       | Boolean |
| actionKey      | Returns true or false if action key was pressed                      | Nothing       | Boolean |
| meleeKey       | Returns true or false if melee key was pressed                       | Nothing       | Boolean |
| reloadKey      | Returns true or false if reload key was pressed                      | Nothing       | Boolean |
| weaponPTH      | Primary trigger state of the current weapon of the biped             | Nothing       | Boolean |
| weaponSTH      | Secondary trigger state of the current weapon of the biped           | Nothing       | Boolean |
| grenadeHold    | Player controlling the biped is holding the grenade button           | Nothing       | Boolean |
| actionKeyHold  | Player controlling the biped is holding the action button            | Nothing       | Boolean |
| crouch         | Current crouch state of the biped                                    | Nothing       | Boolean |
| shooting       | Returns 0.0 or 1.0 if the biped is shooting                          | Nothing       | Number  |
| weaponSlot     | Current weapon slot of the biped, starts from 0 to 3                 | Byte          | Number  |
| zoomLevel      | Current level of zoom of the biped, 255 means no zoom, starts from 0 | Byte          | Number  |
| invisibleScale | Scale amount of the invisibility                                     | Float         | Number  |
| primaryNades   | Count of current primary nades of the biped                          | Byte          | Number  |
| secondaryNades | Count of current secondary nades nades of the biped                  | Byte          | Number  |

## Supported tags objects and properties:

### Unicode String List Tag
> Can contain text about the name of **weapons, vehicles, ui widgets, huds, etc**.

| Property Name | Description                                          | Takes         | Returns       |
| ------------- | ---------------------------------------------------- | ------------- | ------------- |
| count         | Quantity of strings on the tag                       | Nothing       | Number        |
| stringList    | Array containing the text of every string on the tag | Array[string] | Array[string] |


## Implementing LuaBlam
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
