-- Blam library for Chimera Lua scripting.
-- Version 2.0
-- This library is intended to help and improve object memory handle using Lua, to make a standar for modding and avoid large script files.

--[[

        THIS IS AN UNNOFICIAL VERSION, JUST FOR TESTING, DO NOT DISTRIBUTE THIS LIBRARY

Changelog:

2.0: Insane optimization, expanded object structures and available properties, better implentation for reading and writing data
    - Introducing "dataReclaimer", this is an array with specific values for structure fields
    - Improved bit2bool convertion now only 1 as bit value is being interpreted as true any other value will be always false.

    To reduce large value names in every object and avoid being repetitive, a "dataReclaimer" is needed, made of multiple values that are arrays (instead of using properties such as "offset", "type", etc)

    A dataReclaimer is an specific format of data that aims to "reclaim" data for writing or reading

    Here is an example of a dataReclaimer for an object "x"...

    local exampleStructure = {
        dataReclaimer = {0x213, 0}
    }

    Where dataReclaimer is an array with a specific ordered data:

    dataReclaimer[0] -- Is the offset in the memory to read/write a value
    dataReclaimer[1] -- Specify the type of value to read/write

    0 = bit
    1 = byte
    2 = short
    3 = word
    4 = int
    5 = dword
    6 = float
    7 = double
    8 = char
    9 = string

    If we want to use a specific bit position then an extra value is sent in the array:

    dataReclaimer = {0x213, 0, 8}

    This means the position of the bit that is being intented to read/write.
    

1.1: Changes for writable and readable biped properties.

1.0: First realease for Flood 09, biped handle ready.

]] luablam = {}

local function bit2bool(bit) -- Convert bits into boolean values (Writing true or false is equal to 1 or 0 but not when reading)
    if (bit == 1) then return true end
    return false
end

local function dispatchOperation(dataReclaimer, operation, value) -- Decide wich operation will be performed by the the "reclaimer" object
    if (operation == true) then -- Looking for writing
        if (dataReclaimer[2] == 0) then -- Bit
            write_bit(dataReclaimer[1], dataReclaimer[#dataReclaimer], value)
        elseif (dataReclaimer[2] == 1) then -- Byte
            write_byte(dataReclaimer[1], value)
        elseif (dataReclaimer[2] == 2) then -- Short
            write_short(dataReclaimer[1], value)
        elseif (dataReclaimer[2] == 3) then -- Word
            write_word(dataReclaimer[1], value)
        elseif (dataReclaimer[2] == 4) then -- Int
            write_int(dataReclaimer[1], value)
        elseif (dataReclaimer[2] == 5) then -- Dword
            write_dword(dataReclaimer[1], value)
        elseif (dataReclaimer[2] == 6) then -- Float
            write_float(dataReclaimer[1], value)
        elseif (dataReclaimer[2] == 7) then -- Double
            write_double(dataReclaimer[1], value)
        elseif (dataReclaimer[2] == 8) then -- Char
            write_char(dataReclaimer[1], value)
        elseif (dataReclaimer[2] == 9) then -- String
            write_string(dataReclaimer[1], value)
        end
    else -- Looking for reading
        if (dataReclaimer[2] == 0) then -- Is bit type
            return bit2bool(read_bit(dataReclaimer[1],dataReclaimer[#dataReclaimer]))
        elseif (dataReclaimer[2] == 1) then -- Byte
            return read_byte(dataReclaimer[1])
        elseif (dataReclaimer[2] == 2) then -- Short
            return read_short(dataReclaimer[1])
        elseif (dataReclaimer[2] == 3) then -- Word
            return read_word(dataReclaimer[1])
        elseif (dataReclaimer[2] == 4) then -- Int
            return read_int(dataReclaimer[1])
        elseif (dataReclaimer[2] == 5) then -- Dword
            return read_dword(dataReclaimer[1])
        elseif (dataReclaimer[2] == 6) then -- Float
            return read_float(dataReclaimer[1])
        elseif (dataReclaimer[2] == 7) then -- Double
            return read_double(dataReclaimer[1])
        elseif (dataReclaimer[2] == 8) then -- Char
            return read_char(dataReclaimer[1])
        elseif (dataReclaimer[2] == 9) then -- String
            return read_string(dataReclaimer[1])
        end
    end
end

local objectStructure = {
    tagId = {0, 5}, -- WORKING
    collision = {0x10, 0, 0}, -- NOT TESTED
    isOnGround = {0x10, 0, 1}, -- WORKING
    ignoreGravity = {0x10, 0, 2}, -- NOT TESTED
    isOutSideMap = {0x10, 0, 21}, -- NOT TESTED
    collideable = {0x10, 0, 24}, -- NOT TESTED
    health = {0xE0, 6}, -- WORKING
    shield = {0xE4, 6}, -- WORKING
    x = {0x5C, 6}, -- NOT TESTED
    y = {0x60, 6}, -- NOT TESTED
    z = {0x64, 6}, -- NOT TESTED
    xVel = {0x68, 6}, -- WORKING
    yVel = {0x6C, 6}, -- WORKING
    zVel = {0x70, 6}, -- WORKING
    pitch = {0x74, 6}, -- NOT TESTED
    yaw = {0x78, 6}, -- NOT TESTED
    roll = {0x7C, 6}, -- NOT TESTED
    xScale = {0x80, 6}, -- NOT TESTED
    yScale = {0x84, 6}, -- NOT TESTED
    zScale = {0x88, 6}, -- NOT TESTED
    pitchVel = {0x8C, 6}, -- NOT TESTED
    yawVel = {0x90, 6}, -- NOT TESTED
    rollVel = {0x94, 6}, -- NOT TESTED
    type = {0xB4, 3}, -- WORKING (0 = Biped) (1 = Vehicle) (2 = Weapon) (3 = Equipment) (4 = Garbage) (5 = Projectile) (6 = Scenery) (7 = Machine) (8 = Control) (9 = Light Fixture) (10 = Placeholder) (11 = Sound Scenery)
    animation = {0xD0, 3}, -- WORKING
    animationTimer = {0xD2, 3}, -- WORKING
    regionPermutation1 = {0x180, 1}, -- WORKING
    regionPermutation2 = {0x181, 1}, -- WORKING
    regionPermutation3 = {0x182, 1}, -- WORKING
    regionPermutation4 = {0x183, 1}, -- WORKING
    regionPermutation5 = {0x184, 1}, -- WORKING
    regionPermutation6 = {0x185, 1}, -- WORKING
    regionPermutation7 = {0x186, 1}, -- WORKING
    regionPermutation8 = {0x187, 1} -- WORKING
}

local bipedStructure = {
    invisible = {0x204, 0, 4}, -- WORKING
    noDropItems = {0x204, 0, 20}, -- WORKING
    flashlight = {0x204, 0, 19}, -- WORKING
    crouchHold = {0x208, 0, 0}, -- WORKING
    jumpHold = {0x208, 0, 1}, -- WORKING
    flashlightKey = {0x208, 0, 4}, --WORKING
    actionKey = {0x208, 0, 6}, -- WORKING
    meleeKey = {0x208, 0, 7}, -- WORKING
    reloadKey = {0x208, 0, 10},  -- WORKING
    weaponPTH = {0x208, 0, 11}, -- WORKING
    weaponSTH = {0x208, 0, 12}, -- WORKING
    grenadeHold = {0x208, 0, 13}, -- WORKING, similar to weaponSTH.
    actionKeyHold = {0x208, 0, 14}, -- WORKING
    crouch = {0x2A0, 1}, -- WORKING
    shooting = {0x284, 6}, -- WORKING, this is being read as a float, but acts like a boolean
    weaponSlot = {0x2A1, 1}, -- WORKING, starts from 0.
    zoomLevel = {0x320, 1}, -- WORKING, 255 if there is no actual zoom, zoom levels starts from 0.
    invisibleScale = {0x37C, 6}, -- WORKING
    primaryNades = {0x31E, 1}, -- WORKING
    secondaryNades = {0x31F, 1} -- WORKING
}

local availableObjectTypes = {
    object = {objectStructure},
    biped = {objectStructure, bipedStructure}
}

local function proccessRequestedObject(desiredObject, address, properties)
    local outputProperties -- Create a temporal object to store returned properties
    if (address ~= nil) then
        if (properties ~= nil) then -- We want to write properties
            for inputProperty, propertyValue in pairs(properties) do -- For each requsted property we store, name of the property and his value
                for requestedStructure, proccesedStructure in pairs(availableObjectTypes[desiredObject]) do
                    for structureProperty, dataReclaimer in pairs(proccesedStructure) do
                        if (inputProperty == structureProperty) then
                            local newReclaimer = {}
                            for i = 1, #dataReclaimer do
                                newReclaimer[i] = dataReclaimer[i]
                            end
                            newReclaimer[1] = address + dataReclaimer[1] -- Object address plus memory offset
                            dispatchOperation(newReclaimer, true, propertyValue) -- Send data to write proccess
                        end
                    end
                end
            end
        else
            outputProperties = {} -- Initialize object
            for requestedStructure, proccesedStructure in pairs(availableObjectTypes[desiredObject]) do
                for structureProperty, dataReclaimer in pairs(proccesedStructure) do
                    local newReclaimer = {}
                    for i = 1, #dataReclaimer do
                        newReclaimer[i] = dataReclaimer[i]
                    end
                    newReclaimer[1] = address + dataReclaimer[1] -- Object address plus memory offset
                    outputProperties[structureProperty] = dispatchOperation(newReclaimer, false) -- Only push object data
                end
            end
        end
    end
    return outputProperties
end

local function object(address, properties)
    return proccessRequestedObject("object", address, properties)
end

local function biped(address, properties)
    return proccessRequestedObject("biped", address, properties)
end

luablam.biped = biped
luablam.object = object
return luablam

