# lua-blam v1.0.0

## What is lua-blam?

Is a Lua library/module for scripting that allows you to handle Halo Custom Edition memory as
objects in your script, it also includes some features as API extension and unification between
Chimera and SAPP.

## What is intended for?

LuaBlam aims to make easier and more understandable scripts providing simple syntax and accesible
API functions making a standard for game memory editing.

## Highlights

- Simple to implement and simple to learn
- Highly customizable
- Cross-platform (Chimera, SAPP)
- In code documentation
- Auto completion (using [EmmyLua](https://github.com/EmmyLua))

## Example with lua-blam:

```lua
-- Make current player invisible with flashlight key
local player = blam.biped(get_dynamic_player())
if (player and player.flaslightKey) then
    player.invisible = true
end
```

## Example without lua-blam:

```lua
-- Make current player invisible with flashlight key
local playerAddress = get_dynamic_player()
if (playerAddress) then
    local player = get_object(playerAddress)
    if (player) then
        local playerFlashlightKey = read_bit(player + 0x208, 8)
        if (playerFlashlightKey == 1) then
            write_bit(player + 0x204, 4, 1)
        end
    end
end
```

## Visual Studio Code Integration using [VSCode-EmmyLua](https://github.com/EmmyLua/VSCode-EmmyLua):

![lua-blamvscode](https://i.imgur.com/Ai2SuFH.gif)

## Support

If you want to have assistance about how to use this module, join the
[Shadowmods Discord Server](https://discord.shadowmods.net/) to get help on the scripting channel.
