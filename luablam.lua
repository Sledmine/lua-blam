-- Blam library for Chimera Lua scripting.
-- Version 1.0
-- This library is intended to help and improve object memory handle using Lua, to make a standar for modding and avoid large script files.

luablam = {}

local function ifbit(bit)
    if (bit == 0) then
        return false
    else
        return true
    end
end

local function biped(address, data)
    local objectMemory = address
    local bipd
    if (objectMemory ~= nil) then
        bipd = {
            tagId = read_dword(objectMemory),
            health = read_float(objectMemory + 0xE0),
            shield = read_float(objectMemory + 0xE4),
            x = read_float(objectMemory + 0x5C),
            y = read_float(objectMemory + 0x60),
            z = read_float(objectMemory + 0x64),
            xVel = read_float(objectMemory + 0x68),
            yVel = read_float(objectMemory + 0x6C),
            zVel = read_float(objectMemory + 0x70),
            pitch = read_float(objectMemory + 0x74),
            yaw = read_float(objectMemory + 0x78),
            animation = read_word(objectMemory + 0xD0),
            animationTimer = read_word(objectMemory + 0xD2),
            crouch = read_byte(objectMemory + 0x2A0),
            weaponSlot = read_byte(objectMemory + 0x2A1),
            flashlight = ifbit(read_bit(objectMemory + 0x204, 19)),
            invisible = ifbit(read_bit(objectMemory + 0x204, 4)),
            currentNade = read_byte(objectMemory + 0x31C),
            fragGrenades = read_byte(objectMemory + 0x31E),
            plasmaGrenades = read_byte(objectMemory + 0x31F),
            zoomLevel = read_byte(objectMemory + 0x320),
            currentWeapon = read_dword(objectMemory + 0x118),
            regionPermutation1 = read_char(objectMemory + 0x180),
            regionPermutation2 = read_char(objectMemory + 0x181),
        }
    end
    local bipedWritableValues = {
        tagId = function() write_dword(objectMemory, data.tag_id) end,
        x = function() write_float(objectMemory + 0x5C, data.x) end,
        y = function() write_float(objectMemory + 0x60, data.y) end,
        z = function() write_float(objectMemory + 0x64, data.z) end,
        xVel = function() write_float(objectMemory + 0x68, data.xVel) end,
        yVel = function() write_float(objectMemory + 0x6C, data.yVel) end,
        zVel = function() write_float(objectMemory + 0x70, data.zVel) end,
        pitch = function() write_float(objectMemory + 0x74, data.pitch) end,
        yaw = function() write_float(objectMemory + 0x78, data.yaw) end,
        animation = function() write_word(objectMemory + 0xD0, data.animation) end,
        animationTimer = function() write_word(objectMemory + 0xD2, data.animationTimer) end,
        crouch = function() write_byte(objectMemory + 0x2A0, data.crouch) end,
        weaponSlot = function() write_byte(objectMemory + 0x2A1, data.weaponSlot) end,
        flashlight = function() write_bit(objectMemory + 0x204, 19, data.flashlight) end,
        invisible = function() write_bit(objectMemory + 0x204, 4, data.invisible) end,
        currentNade = function() write_byte(objectMemory + 0x31C, data.currentNade) end,
        fragGrenades = function() write_byte(objectMemory + 0x31E, data.fragGrenades) end,
        plasmaGrenades = function() write_byte(objectMemory + 0x31F, data.plasmaGrenades) end,
        zoomLevel = function() write_byte(objectMemory + 0x320, data.zoomLevel) end,
        regionPermutation1 = function() write_char(objectMemory + 0x180, data.region_permutation_1) end,
        regionPermutation2 = function() write_char(objectMemory + 0x181, data.region_permutation_2) end
    }
    if (data ~= nil) then
        for i,v in pairs(data) do
            for j,k in pairs(bipedWritableValues) do
                if (i == j) then
                    bipedWritableValues[i]()
                end
            end
        end
    end
    return bipd
end

luablam.biped = biped
return luablam

