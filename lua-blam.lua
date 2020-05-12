------------------------------------------------------------------------------
-- Blam library for Chimera/SAPP Lua scripting.
-- Authors: Sledmine
-- Version: 3.5
-- Improves memory handle and provides standard functions for scripting
------------------------------------------------------------------------------
--[[

Changelog:

3.5:
    Added model animations type. (16 = FPWAnimL)

3.4: Added sound class type.

3.3: Added vertex list reading for collision geometries.
    - Added dataReclaimer for collsions vertices. (15 = VertexL)

3.2: Fixed vehicle list rotation, added new unified API function.
    - Added binding for "execute_script" function from Chimera to SAPP.

3.1: Scenario vehicle list is available now.
    - Object dataReclaimer now supports scenario vehicles list (14 = VehicleL).

3.0: Added global compatibility API functions for SAPP and Chimera.
    - Extra standard functions were added (get_tag_id, get_tag_path)

2.1: New tag data handle added, implemented string metable.
    - Added support for ui widgets definition (UNCOMPLETE, MORE VALUES REQUIRED).
    - Added support for weapon hud interfaces (UNSTABLE, HARDCODED TO FIRST CROSSHAIR ELEMENT).
    - Added support for unicode string lists.
    - Added playerIsLookingAt function.
    - Object dataReclaimer now supports unicode string list (10 = UStringL).
    - Object dataReclaimer now supports scenery palette list (11 = SceneryPL). -- Only for reading
    - Object dataReclaimer now supports child ui widgets list (12 = ChildWL). -- Only for reading
    - Object dataReclaimer now supports player starting locations list (13 = PlayerSLL).

2.0: Insane optimization, expanded object structures and available properties, better implentation for reading and writing data.

    - Introducing "dataReclaimer", this is an array with specific values for structure fields
    - Improved bit2bool convertion now only 1 as bit value is being interpreted as true any other value will be always false.

    dataReclaimer is an array with a specific ordered data:

    dataReclaimer[0] -- Memory address to read/write a value
    dataReclaimer[1] -- Specify the type of value to read/write

    0 = Bit
    1 = Byte
    2 = Short
    3 = Word
    4 = Int
    5 = Dword
    6 = Float
    7 = Double
    8 = Char
    9 = String

    In case of reading/writing a bit value we can set a specific bit position sending an extra value in the array:

    dataReclaimer = {0x213, 0, 8}
                                ^
                                |
                                |
                                This means the position of the bit that we are seeking to read/write.

1.1: Changes for writable and readable biped properties.

1.0: First realease for Flood 09, biped handle ready.

]]
luablam = {}

if (api_version) then
    -- SAPP is importing the library
    -- Create and bind Chimera functions to the ones in SAPP
    function get_tag(typeOrTagId, path)
        if (not path) then
            return lookup_tag(typeOrTagId)
        else
            return lookup_tag(typeOrTagId, path)
        end
    end

    function execute_script(command)
        execute_command(command)
    end

    function get_object(objectId)
        if (objectId) then
            local object_memory = get_object_memory(objectId)
            if (object_memory ~= 0) then
                return object_memory
            end
        end
        return nil
    end

    function delete_object(objectId)
        destroy_object(objectId)
    end

    function console_out(message)
        print(message)
    end

    print('Chimera API functions are available now with LuaBlam!')
end

function get_tag_id(type, path)
    local global_tag_address = get_tag(type, path)
    if (global_tag_address and global_tag_address ~= 0) then
        local tag_id = global_tag_address + 0xC
        return read_dword(tag_id)
    end
    return nil
end

function get_tag_path(tagId)
    local tag_string_path_address = read_dword(get_tag(tagId) + 0x10)
    return read_string(tag_string_path_address)
end

function get_tag_type(tagId)
    local type = ''
    for i = 0, 3 do
        type = type .. string.char(read_char(get_tag(tagId) + i))
    end
    return type:reverse()
end

function get_tags_count()
    return read_word(0x4044000C)
end

-- ONLY WORKS FOR CHIMERA!!!
---@return table objectsList
function get_objects()
    local objectsList = {}
    for i = 0, 1023 do
        if (get_object(i)) then
            objectsList[#objectsList + 1] = i
        end
    end
    return objectsList
end

print('LuaBlam extra API functions were loaded!')

-- Allow the script to handle strings as an array
getmetatable('').__index = function(str, i)
    if type(i) == 'number' then
        return string.sub(str, i, i)
    else
        return string[i]
    end
end

local function bit2bool(bit) -- Convert bits into boolean values (Writing true or false is equal to 1 or 0 but not when reading)
    if (bit == 1) then
        return true
    end
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
        elseif (dataReclaimer[2] == 10) then -- UStringL
            local stringCount = read_byte(dataReclaimer[1] - 0x4)
            local stringListAddress = read_dword(dataReclaimer[1])
            local incomingStrings = #value
            local availableStrings = incomingStrings
            if (incomingStrings > stringCount) then
                availableStrings = stringCount
            end
            for i = 1, availableStrings do
                --local stringSize = read_dword(stringListAddress) / 2
                local stringValueAddress = read_dword(stringListAddress + 0xC)
                for j = 1, #value[i] do
                    write_string(stringValueAddress, value[i][j])
                    stringValueAddress = stringValueAddress + 0x2
                    if (j == #value[i]) then
                        write_byte(stringValueAddress, 0x0)
                    end
                end
                stringListAddress = stringListAddress + 0x14
            end
        elseif (dataReclaimer[2] == 13) then -- SpawnLL
            local spawnLocationCount = read_dword(dataReclaimer[1] - 0x4)
            local spawnLocationListAddress = read_dword(dataReclaimer[1])
            for i = 1, spawnLocationCount do
                -- Entity creation for every spawn location
                local spawnLocation = value[i]
                write_float(spawnLocationListAddress, spawnLocation.x)
                write_float(spawnLocationListAddress + 0x4, spawnLocation.y)
                write_float(spawnLocationListAddress + 0x8, spawnLocation.z)
                write_byte(spawnLocationListAddress + 0x14, spawnLocation.type)
                write_float(spawnLocationListAddress + 0xC, spawnLocation.rotation)
                if (spawnLocation.teamIndex) then
                    write_byte(spawnLocationListAddress + 0x10, spawnLocation.teamIndex)
                end
                spawnLocationListAddress = spawnLocationListAddress + 0x34
            end
        elseif (dataReclaimer[2] == 14) then -- SpawnLL
            local vehicleCount = read_dword(dataReclaimer[1] - 0x4)
            local vehicleListAddress = read_dword(dataReclaimer[1])
            for i = 1, vehicleCount do
                -- Entity creation for every spawn location
                local vehicle = value[i]
                write_word(vehicleListAddress, vehicle.type)
                --write_word(vehicleListAddress + 0x2, vehicle.nameIndex)
                write_float(vehicleListAddress + 0x8, vehicle.x)
                write_float(vehicleListAddress + 0xC, vehicle.y)
                write_float(vehicleListAddress + 0x10, vehicle.z)
                write_float(vehicleListAddress + 0x14, vehicle.yaw)
                write_float(vehicleListAddress + 0x18, vehicle.pitch)
                write_float(vehicleListAddress + 0x1C, vehicle.roll)
                vehicleListAddress = vehicleListAddress + 0x78
            end
        elseif (dataReclaimer[2] == 16) then -- MEEEEEEE
            local fpAnimationCount = read_word(dataReclaimer[1])
            local fpAnimationAddressList = read_dword(dataReclaimer[1] + 0x4)

            local fpAnimationList = {}

            for i = 1, fpAnimationCount do
                write_byte(fpAnimationAddressList, value[i])
                fpAnimationAddressList = fpAnimationAddressList + 0x2
            end
        end
    else -- Looking for reading
        if (dataReclaimer[2] == 0) then -- Is bit type
            return bit2bool(read_bit(dataReclaimer[1], dataReclaimer[#dataReclaimer]))
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
        elseif (dataReclaimer[2] == 10) then -- UStringL
            local stringCount = read_byte(dataReclaimer[1] - 0x4)
            local stringListAddress = read_dword(dataReclaimer[1])
            local stringList = {}
            for i = 1, stringCount do
                local stringSize = read_dword(stringListAddress) / 2
                local stringValueAddress = read_dword(stringListAddress + 0xC)
                local stringValue = ''
                for j = 1, stringSize do
                    local charValue = read_string(stringValueAddress)
                    if (charValue == '') then
                        break
                    end
                    stringValue = stringValue .. charValue
                    stringValueAddress = stringValueAddress + 0x2
                end
                stringList[i] = stringValue
                stringListAddress = stringListAddress + 0x14
            end
            return stringList
        elseif (dataReclaimer[2] == 11) then -- SceneryPL
            local sceneryCount = read_dword(dataReclaimer[1] - 0x4)
            local sceneryListAddress = read_dword(dataReclaimer[1])
            local sceneryList = {}
            for i = 1, sceneryCount do
                local sceneryIndex = read_dword(sceneryListAddress + 0xC)
                sceneryList[i] = sceneryIndex
                sceneryListAddress = sceneryListAddress + 0x30
            end
            return sceneryList
        elseif (dataReclaimer[2] == 12) then -- ChildWL
            local childWidgetCount = read_dword(dataReclaimer[1] - 0x4)
            local childWidgetListAddress = read_dword(dataReclaimer[1])
            local childWidgetList = {}
            for i = 1, childWidgetCount do
                local childWidgetIndex = read_dword(childWidgetListAddress + 0xC)
                childWidgetList[i] = childWidgetIndex
                childWidgetListAddress = childWidgetListAddress + 0x50
            end
            return childWidgetList
        elseif (dataReclaimer[2] == 13) then -- PlayerSLL
            local spawnLocationCount = read_dword(dataReclaimer[1] - 0x4)
            local spawnLocationListAddress = read_dword(dataReclaimer[1])

            -- Entities list for spawns
            local spawnLocationList = {}

            for i = 1, spawnLocationCount do
                -- Entity creation for every spawn location
                local spawnLocation = {}
                spawnLocation.x = read_float(spawnLocationListAddress)
                spawnLocation.y = read_float(spawnLocationListAddress + 0x4)
                spawnLocation.z = read_float(spawnLocationListAddress + 0x8)
                spawnLocation.rotation = read_float(spawnLocationListAddress + 0xC)
                spawnLocation.teamIndex = read_byte(spawnLocationListAddress + 0x10)
                spawnLocation.bspIndex = read_short(spawnLocationListAddress + 0x12)
                spawnLocation.type = read_byte(spawnLocationListAddress + 0x14)

                spawnLocationList[i] = spawnLocation
                spawnLocationListAddress = spawnLocationListAddress + 0x34
            end
            return spawnLocationList
        elseif (dataReclaimer[2] == 14) then -- VehicleSL
            local vehicleCount = read_dword(dataReclaimer[1] - 0x4)
            local vehicleListAddress = read_dword(dataReclaimer[1])

            -- Entities list for spawns
            local vehicleList = {}

            for i = 1, vehicleCount do
                -- Entity creation for every spawn location
                local vehicle = {}
                vehicle.type = read_word(vehicleListAddress)
                vehicle.nameIndex = read_word(vehicleListAddress + 0x2)
                vehicle.x = read_float(vehicleListAddress + 0x8)
                vehicle.y = read_float(vehicleListAddress + 0xC)
                vehicle.z = read_float(vehicleListAddress + 0x10)
                vehicle.yaw = read_float(vehicleListAddress + 0x14)
                vehicle.pitch = read_float(vehicleListAddress + 0x18)
                vehicle.roll = read_float(vehicleListAddress + 0x1C)
                vehicleList[i] = vehicle
                vehicleListAddress = vehicleListAddress + 0x78
            end
            return vehicleList
        elseif (dataReclaimer[2] == 15) then -- VertexL
            local vertexCount = read_dword(dataReclaimer[1] - 0x4)
            local vertexAdressList = read_dword(dataReclaimer[1])

            local vertexList = {}

            for i = 1, vertexCount do
                local vertex = {}
                vertex.x = read_float(vertexAdressList)
                vertex.y = read_float(vertexAdressList + 0x4)
                vertex.z = read_float(vertexAdressList + 0x8)
                vertexList[i] = vertex
                vertexAdressList = vertexAdressList + 0x10
            end
            return vertexList
        elseif (dataReclaimer[2] == 16) then -- FPAnimL
            local fpAnimationCount = read_word(dataReclaimer[1])
            local fpAnimationAddressList = read_dword(dataReclaimer[1] + 0x4)
            local fpAnimationList = {}

            for i = 1, fpAnimationCount do
                local value = read_byte(fpAnimationAddressList)
                fpAnimationList[i] = value
                fpAnimationAddressList = fpAnimationAddressList + 0x2
            end
            return fpAnimationList
        elseif (dataReclaimer[2] == 17) then -- AnimL
            local animationCount = read_word(dataReclaimer[1] - 0x4)
            local animationAddressList = read_dword(dataReclaimer[1])
            local animationList = {}

            for i = 1, animationCount do
                local animation = {}

                animation.name = read_string(animationAddressList)
                animation.type = read_word(animationAddressList + 0x20)
                animation.frameCount = read_byte(animationAddressList + 0x22)
                animation.nextAnimation = read_byte(animationAddressList + 0x38)
                animation.sound = read_byte(animationAddressList + 0x3C)

                animationList[i] = animation
                animationAddressList = animationAddressList + 0xB4
            end
            return animationList
        end
    end
end

local objectStructure = {
    tagId = {0x0, 5},
    collision = {0x10, 0, 0},
    isOnGround = {0x10, 0, 1},
    ignoreGravity = {0x10, 0, 2},
    isOutSideMap = {0x12, 0, 5},
    collideable = {0x10, 0, 4},
    health = {0xE0, 6},
    shield = {0xE4, 6},
    redA = {0x1B8, 6},
    greenA = {0x1BC, 6},
    blueA = {0x1C0, 6},
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
    --[[
     (0 = Biped)
     (1 = Vehicle)
     (2 = Weapon)
     (3 = Equipment)
     (4 = Garbage)
     (5 = Projectile)
     (6 = Scenery)
     (7 = Machine)
     (8 = Control)
     (9 = Light Fixture)
     (10 = Placeholder)
     (11 = Sound Scenery)
    ]]
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

local bipedStructure = {
    invisible = {0x204, 0, 4},
    noDropItems = {0x204, 0, 20},
    flashlight = {0x204, 0, 19},
    cameraX = {0x230, 6},
    cameraY = {0x234, 6},
    cameraZ = {0x238, 6},
    crouchHold = {0x208, 0, 0},
    jumpHold = {0x208, 0, 1},
    actionKeyHold = {0x208, 0, 14},
    actionKey = {0x208, 0, 6},
    meleeKey = {0x208, 0, 7},
    reloadKey = {0x208, 0, 10},
    weaponPTH = {0x208, 0, 11},
    weaponSTH = {0x208, 0, 12},
    flashlightKey = {0x208, 0, 4},
    grenadeHold = {0x208, 0, 13},
    crouch = {0x2A0, 1},
    shooting = {0x284, 6},
    weaponSlot = {0x2A1, 1},
    zoomLevel = {0x320, 1},
    invisibleScale = {0x37C, 6},
    primaryNades = {0x31E, 1},
    secondaryNades = {0x31F, 1}
}

local unicodeStringListStructure = {
    count = {0x0, 1},
    stringList = {0x4, 10}
}

local uiWidgetDefinitionStructure = {
    type = {0x0, 3},
    controllerIndex = {0x2, 3},
    name = {0x4, 9},
    boundsY = {0x24, 2},
    boundsX = {0x26, 2},
    height = {0x28, 2},
    width = {0x2A, 2},
    backgroundBitmap = {0x44, 3},
    eventType = {0x03F0, 1},
    tagReference = {0x400, 3},
    childWidgetsCount = {0x03E0, 5},
    childWidgetsList = {0x03E4, 12}
}

local weaponHudInterfaceStructure = {
    crosshairs = {0x84, 3},
    defaultBlue = {0x208, 1},
    defaultGreen = {0x209, 1},
    defaultRed = {0x20A, 1},
    defaultAlpha = {0x20B, 1},
    --flashingColor = {0x20C, 1},
    sequenceIndex = {0x22A, 2}
}

local scenarioStructure = {
    sceneryPaletteCount = {0x021C, 5},
    sceneryPaletteList = {0x220, 11},
    spawnLocationCount = {0x354, 5},
    spawnLocationList = {0x358, 13},
    vehicleLocationCount = {0x240, 5},
    vehicleLocationList = {0x244, 14}
}

local sceneryStructure = {
    model = {0x28 + 0xC, 3},
    modifierShader = {0x90 + 0xC, 3}
}

local collisionGeometryStructure = {
    vertexCount = {0x408, 5},
    vertexList = {0x40C, 15}
}

local modelAnimations = {
    fpAnimationList = {0x90, 16},
    animationCount = {0x74, 5},
    animationList = {0x78, 17}
}

local sound = {
    class = {0x4, 0x2}
}

local availableObjectTypes = {
    object = {objectStructure},
    biped = {objectStructure, bipedStructure},
    uiWidgetDefinition = {uiWidgetDefinitionStructure},
    weaponHudInterface = {weaponHudInterfaceStructure},
    unicodeStringList = {unicodeStringListStructure},
    scenario = {scenarioStructure},
    scenery = {sceneryStructure},
    collisionGeometry = {collisionGeometryStructure},
    sound = {sound},
    modelAnimations = {modelAnimations}
}

local function proccessRequestedObject(desiredObject, address, properties)
    local outputProperties  -- Create a temporal object to store returned properties
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

---@param address number
---@param properties nil | table
function luablam.object(address, properties)
    if (address and address ~= 0) then
        return proccessRequestedObject('object', address, properties)
    end
    return nil
end

---@param address number
---@param properties nil | table
function luablam.biped(address, properties)
    if (address and address ~= 0) then
        return proccessRequestedObject('biped', address, properties)
    end
    return nil
end

---@param address number
---@param properties nil | table
function luablam.uiWidgetDefinition(address, properties)
    if (address and address ~= 0) then
        local tagDataAddress = read_dword(address + 0x14)
        return proccessRequestedObject('uiWidgetDefinition', tagDataAddress, properties)
    end
    return nil
end

function luablam.weaponHudInterface(address, properties)
    if (address and address ~= 0) then
        local tagDataAddress = read_dword(address + 0x14)
        return proccessRequestedObject('weaponHudInterface', tagDataAddress, properties)
    end
    return nil
end

---@param address number
---@param properties nil | table
function luablam.unicodeStringList(address, properties)
    if (address and address ~= 0) then
        local tagDataAddress = read_dword(address + 0x14)
        return proccessRequestedObject('unicodeStringList', tagDataAddress, properties)
    end
    return nil
end

---@param address number
---@param properties nil | table
function luablam.scenario(address, properties)
    if (address and address ~= nil) then
        local tagDataAddress = read_dword(address + 0x14)
        return proccessRequestedObject('scenario', tagDataAddress, properties)
    end
end

---@param address number
---@param properties nil | table
function luablam.scenery(address, properties)
    if (address and address ~= 0) then
        local tagDataAddress = read_dword(address + 0x14)
        return proccessRequestedObject('scenery', tagDataAddress, properties)
    end
    return nil
end

---@param address number
---@param properties nil | table
function luablam.collisionGeometry(address, properties)
    if (address and address ~= 0) then
        local tagDataAddress = read_dword(address + 0x14)
        return proccessRequestedObject('collisionGeometry', tagDataAddress, properties)
    end

    return nil
end

---@param address number
---@param properties nil | table
function luablam.sound(address, properties)
    if (address and address ~= 0) then
        local tagDataAddress = read_dword(address + 0x14)
        return proccessRequestedObject('sound', tagDataAddress, properties)
    end
    return nil
end

function luablam.modelAnimations(address, properties)
    if (address and address ~= 0) then
        local tagDataAddress = read_dword(address + 0x14)
        return proccessRequestedObject('modelAnimations', tagDataAddress, properties)
    end
    return nil
end

return luablam
