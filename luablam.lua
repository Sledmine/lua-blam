-- Blam library for Chimera Lua scripting.
-- Version 2.0
-- This library is intended to help and improve object memory handle using Lua, to make a standar for modding and avoid large script files.
--[[

Changelog:

2.0: Insane optimization, expanded object structures and available properties, better implentation for reading and writing data
    - Introducing "dataReclaimer", this is an array with specific values for structure fields
    - Improved bit2bool convertion now only 1 as bit value is being interpreted as true any other value will be always false.

    To reduce large value names in every object and avoid being repetitive, a "dataReclaimer" is needed, made of multiple values that are arrays (instead of using properties such as "offset", "type", etc)

    A dataReclaimer is an specific format of data that aims to "reclaim" data for writing or reading

    Here is an example of a dataReclaimer for an object "x"...

    local ObjectStructure = {
        dataReclaimer = {0x213, 0}
    }

    Where "dataReclaimer" is an array with a specific ordered data:

    dataReclaimer[0] -- Is the offset in the memory to read/write a value
    dataReclaimer[1] -- Specify the type of value to read/write

    (0 = bit, 1 = byte, 2 = short, 3 = word, 4 = int, 5 = dword, 6 = float, 7 = double, 8 = char, 9 = string)

    If we want to use a specific bit position then an extra value is sent in the array:

    dataReclaimer = {0x213, 0, 8}

    This means the position of the bit that is being intented to read/write.
    

1.1: Changes for writable and readable biped properties.

1.0: First realease for Flood 09, biped handle ready.

]]

luablam = {}

local function bit2bool(bit) -- Convert bits into boolean values (Writing true or false is equal to 1 or 0 but not when reading)
    if (bit == 1) then return true end
    return false
end

local function dispatchOperation(dataReclaimer, operation, value) -- Decide wich operation will be performed by the the "reclaimer" object
    if (operation == true) then -- Looking for writing
        if (dataReclaimer[2] == 0) then -- Is bit type
            write_bit(dataReclaimer[1], dataReclaimer[#dataReclaimer], value)
        end
    else -- Looking for reading
        if (dataReclaimer[2] == 0) then -- Is bit type
            return bit2bool(read_bit(dataReclaimer[1], dataReclaimer[#dataReclaimer]))
        end
    end
end

local objectStructure = {
    tagId = {0, 5},
    collision = {0x10, 0, 0},
    isOnGround = {0x10, 0, 1},
    ignoreGravity = {0x10, 0, 2},
    isOutSideMap = {0x10, 0, 21},
    collideable = {0x10, 0, 24},
    health = {0xE0, 6},
    shield = {0xE4, 6},
    x = {0x5C, 6},
    y = {0x60, 6},
    z = {0x64, 6},
    xVel = {0x68, 6},
    yVel = {0x6C, 6},
    zVel = {0x70, 6},
    pitch = {0x74, 6},
    yaw = {0x78, 6},
    roll = {0x7C, 6},
    xScale = {0x80, 6},
    yScale = {0x84, 6},
    zScale = {0x88, 6},
    pitchVel = {0x8C, 6},
    yawVel = {0x90, 6},
    rollVel = {0x94, 6},
    type = {0xB4, 3},
    animation = {0xD0, 3},
    animationTimer = {0xD2, 3},
    regionPermutation1 = {0x180, 1},
    regionPermutation2 = {0x181, 1},
    regionPermutation3 = {0x182, 1},
    regionPermutation4 = {0x183, 1},
    regionPermutation5 = {0x184, 1},
    regionPermutation6 = {0x185, 1},
    regionPermutation7 = {0x186, 1},
    regionPermutation8 = {0x187, 1}
}

local function object(address, properties)
    local object -- Create a temporal object to store data
    if (address ~= nil) then
        if (properties ~= nil) then -- We want to write properties
            for inputProperty, propertyValue in pairs(properties) do
                for structureProperties, dataReclaimer in pairs(objectStructure) do
                    if (inputProperty == structureProperties) then
                        dataReclaimer[1] = address + dataReclaimer[1] -- Object address plus memory offset
                        dispatchOperation(dataReclaimer, true, propertyValue) -- Send data to write proccess
                    end
                end
            end
        else
            object = {} -- Initialize object
            --[[for structureProperties, dataReclaimer in pairs(objectStructure) do
                dataReclaimer[1] = address + dataReclaimer[1] -- Object address plus memory offset
                object[structureProperties] = dispatchOperation(dataReclaimer, false) -- Only push object data
            end]]
        end
    end
    return object
end

local function biped(address, data)
end

--luablam.biped = biped
luablam.object = object
return luablam

