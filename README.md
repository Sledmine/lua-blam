# LuaBlam

### What is it?

Is a Lua library for scripting that allows you to handle Halo Custom Edition memory as objects in your script, including features as API extension and unification between Chimera and SAPP.

### What is intended for?

LuaBlam aims to make easier and more understandable scripts providing simple syntax and accesible API functions making a standard for game memory editing.

### Highlights

- Simple to implement and simple to learn
- Highly customizable
- Cross-platform (Chimera, SAPP)

### Example with LuaBlam:

```lua
local player = blam.biped(get_dynamic_player())
if (player) then
    if (player.flaslightKey) then
        -- Do awesome stuff!!
    end
end
```

### Example without LuaBlam:

```lua
local playerAddress = get_dynamic_player()
if (playerAddress) then
    local player = get_object(playerAddress)
    if (player) then
        local playerFlashlightKey = read_bit(player + 0x208, 8)
        if (playerFlashlightKey == 1) then
            -- Do more stuff!!
        end
    end
end
```

### Documentation

See the [Wiki](https://github.com/Sledmine/LuaBlam/wiki) for more information!
