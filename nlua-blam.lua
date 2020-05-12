------------------------------------------------------------------------------
-- Blam library for Chimera/SAPP Lua scripting.
-- Authors: Sledmine
-- Version: 4.0
-- Improves memory handle and provides standard functions for scripting
------------------------------------------------------------------------------
local luablam = {}

local operations = {
    bit = {read_bit, write_bit},
    byte = {read_byte, write_byte},
    short = {read_short, write_short},
    word = {read_word, write_word},
    int = {read_int, write_int},
    dword = {read_dword, write_dword}
}

-- Convert bits into boolean values
-- Writing true or false is equal to 1 or 0 but not when reading
local function bit2bool(bit)
    if (bit == 1) then return true end
    return false
end

metatable = {
    __newindex = function(object, property, value)
        --console_out('WRITING data...')
        local propertyData = object.structure[property]
        if (propertyData) then
            local bitLevel = propertyData.bitLevel
            local operation = operations[propertyData.type]
            if (bitLevel) then
                operation[2](object.address + propertyData.offset, bitLevel,
                                value)
            else
                operation[2](object.address + propertyData.offset, value)
            end
        end
    end,
    __index = function(object, property, value)
        --console_out('READING data...')
        local propertyData = object.structure[property]
        if (propertyData) then
            local operation = operations[propertyData.type]
            local bitLevel = propertyData.bitLevel
            if (bitLevel) then
                return bit2bool(operation[1](
                                    object.address + propertyData.offset,
                                    bitLevel))
            else
                return operation[1](object.address + propertyData.offset)
            end
        end
    end
}

-- Biped structure
local bipedStructure = {
    invisible = {type = 'bit', offset = 0x204, bitLevel = 4},
    noDropItems = {type = 'bit', offset = 0x204, bitlevel = 20},
    flashlight = {type = 'bit', offset = 0x204, bitLevel = 19},
    cameraX = {type = 'float', offset = 0x230},
    cameraY = {type = 'float', offset = 0x234},
    cameraZ = {type = 'float', offset = 0x238},
    crouchHold = {type = 'bit', offset = 0x208, bitLevel = 0},
    jumpHold = {type = 'bit', offset = 0x208, bitLevel = 1},
    actionKeyHold = {type = 'bit', offset = 0x208, bitLevel = 14},
    actionKey = {type = 'bit', offset = 0x208, bitLevel = 6},
    meleeKey = {type = 'bit', offset = 0x208, 0, 7},
    reloadKey = {type = 'bit', offset = 0x208, bitLevel = 10},
    weaponPTH = {type = 'bit', offset = 0x208, bitLevel = 11},
    weaponSTH = {type = 'bit', offset = 0x208, bitLevel = 12},
    flashlightKey = {type = 'bit', offset = 0x208, bitLevel = 4},
    grenadeHold = {type = 'bit', offset = 0x208, bitLevel = 13},
    crouch = {type = 'byte', offset = 0x2A0},
    shooting = {type = 'float', offset = 0x284},
    weaponSlot = {type = 'byte', offset = 0x2A1},
    zoomLevel = {type = 'byte', offset = 0x320},
    invisibleScale = {type = 'byte', offset = 0x37C},
    primaryNades = {type = 'byte', offset = 0x31E},
    secondaryNades = {type = 'byte', offset = 0x31F}

    --[[weapons = {
        {jump = 0x64},
        {type = 'byte', offset = 0x378, property = 'name'},
        {type = 'int', offset = 0x867, property = 'damage'}
    }]]
}

-- Remove unused properties for game execution
function cleanObject(t)
    for k, v in pairs(t) do
        if (k ~= 'address' and k ~= 'structure') then t[k] = nil end
    end
end

local bipedClass = {}
function bipedClass.create(address)
    -- Create object "instance"
    local biped = {}
    -- Legacy values
    biped.address = address
    biped.structure = bipedStructure
    
    -- Mockup object properties for IDE
    biped.invisible = false
    biped.noDropItems = false
    biped.flashlight = false
    biped.cameraX = 0
    biped.cameraY = 0
    biped.cameraZ = 0
    biped.crouchHold = false
    biped.jumpHold = false
    biped.actionKeyHold = false
    biped.actionKey = false
    biped.meleeKey = false
    biped.reloadKey = false
    biped.weaponPTH = false
    biped.weaponSTH =  false
    biped.flashlightKey = false
    biped.grenadeHold = false
    biped.crouch = false
    biped.shooting = 0.0
    biped.weaponSlot = 0
    biped.zoomLevel = 0xFF
    biped.invisibleScale = 1
    biped.primaryNades = 0
    biped.secondaryNades = 0
    return biped
end

function luablam.biped(address)
    if (address and address ~= 0) then

        -- Generate a new object from class
        local newBiped = bipedClass.create(address)

        -- Set mechanisim to bind properties to memory
        setmetatable(newBiped, metatable)


        cleanObject(newBiped)

        return newBiped
    end
    return nil
end

return luablam
