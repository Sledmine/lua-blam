# lua-blam v1.2.0

## What is lua-blam?
Is a Lua library/module for scripting that allows you to handle Halo Custom Edition memory as
objects (tables) in your script, it also includes some features as API extension and unification between
Chimera and SAPP.

## What is intended for?
LuaBlam aims to make easier and more understandable scripts providing simple syntax and accesible
API functions making a standard for game memory editing.

## Why should I use it?
Scripting with raw low level functions to edit memory can lead to undesirable situations where you
can introduce lot of harmful errors if you are not careful enough to mantain your code secure and
continuously tested, also readeability for your code is key when it comes to open source scripts or
colaborative work, lua-blam is perfect for both, keeping all the memory handling isolated and tested
separately and helping scripters to write simpler and understandable code with good abstraction.

## Highlights
- Simple to implement and simple to learn
- Highly customizable
- Cross-platform (Chimera, SAPP)
- In code documentation
- Auto completion (using [EmmyLua](https://github.com/EmmyLua))

## Scripting with lua-blam:
```lua
-- Make current player invisible with flashlight key
local player = blam.biped(get_dynamic_player())
if (player and player.flaslightKey) then
    player.invisible = true
end
```

## Scripting without lua-blam:
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

## Installation
Place a copy of the `blam.lua` file in the project folder of your script to enable automcompletion,
to use this module on Halo Custom Edition you need to place the `blam.lua` on the lua modules
of your chimera folder `My Games\Halo CE\chimera\lua\modules`, however if you want to distribute your
script with this module builtin you can take a look at bundling modular lua scripts using
[Mercury](https://github.com/Sledmine/Mercury).

## Documentation
As mentioned above lua-blam provides in code documentation, basically by using EmmyLua all the
documentation needed can be found via automcompletion of the IDE.

Give a look to the examples folder in this repository for real use cases and examples of how to use implement lua-blam.

There is a WIP documentation for Chimera Lua scripting on this repository, also a Changelog is
hosted here:

- [Chimera Lua API Documentation (Work In Progress)](CHIMERA_LUA_API.md)
- [Changelog](CHANGELOG.md)

## Support
If you want to have assistance about how to use this module, join the
[Shadowmods Discord Server](https://discord.shadowmods.net/) to get help on the scripting channel.
