# lua-blam 4.0 
### What is it?

Is a Lua library for scripting that allows you to handle Halo Custom Edition memory as objects in your script, including features as API extension and unification between Chimera and SAPP.

### What is intended for?

LuaBlam aims to make easier and more understandable scripts providing simple syntax and accesible API functions making a standard for game memory editing.

### Highlights

- Simple to implement and simple to learn
- Highly customizable
- Cross-platform (Chimera, SAPP)
- Auto completion for code editors (using EmmyLua)

### Example with lua-blam:

```lua
local player = blam.biped(get_dynamic_player())
if (player) then
    if (player.flaslightKey) then
        -- Do awesome stuff!!
    end
end
```

### Example without lua-blam:

```lua
local playerAddress = get_dynamic_player()
if (playerAddress) then
    local player = get_object(playerAddress)
    if (player) then
        local playerFlashlightKey = read_bit(player + 0x208, 8)
        if (playerFlashlightKey == 1) then
            -- Do probaly less awesome stuff!!
        end
    end
end
```

### Visual Studio Code Integration using [vscode-lua](https://github.com/sumneko/vscode-lua):
![lua-blamvscode](https://i.imgur.com/eQea4mU.gif)


### Documentation

See the [Wiki](https://github.com/Sledmine/LuaBlam/wiki) for more information!
