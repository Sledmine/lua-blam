------------------------------------------------------------------------------
-- Blam library for Chimera/SAPP Lua scripting.
-- Authors: Sledmine & JerryBrick
-- Version: 4.0
-- Improves memory handle and provides standard functions for scripting
------------------------------------------------------------------------------

local luablam = {}

-- LuaBlam version
luablam.version = 4.0


------------------------------------------------------------------------------
-- Blam! engine data
------------------------------------------------------------------------------

-- Address list
local addressList = {
    tagDataHeader = 0x40440000,
    cameraType = 0x00647498 -- from Giraffe
}

-- Provide global tag classes by default
local tagClasses = {
    actorVariant = 'actv',
    actor = 'actr',
    antenna = 'ant!',
    biped = 'bipd',
    bitmap = 'bitm',
    cameraTrack = 'trak',
    colorTable = 'colo',
    continuousDamageEffect = 'cdmg',
    contrail = 'cont',
    damageEffect = 'jpt!',
    decal = 'deca',
    detailObjectCollection = 'dobc',
    deviceControl = 'ctrl',
    deviceLightFixture = 'lifi',
    deviceMachine = 'mach',
    device = 'devi',
    dialogue = 'udlg',
    effect = 'effe',
    equipment = 'eqip',
    flag = 'flag',
    fog = 'fog ',
    font = 'font',
    garbage = 'garb',
    gbxmodel = 'mod2',
    globals = 'matg',
    glow = 'glw!',
    grenadeHudInterface = 'grhi',
    hudGlobals = 'hudg',
    hudMessageText = 'hmt ',
    hudNumber = 'hud#',
    itemCollection = 'itmc',
    item = 'item',
    lensFlare = 'lens',
    lightVolume = 'mgs2',
    light = 'ligh',
    lightning = 'elec',
    materialEffects = 'foot',
    meter = 'metr',
    modelAnimations = 'antr',
    modelCollisiionGeometry = 'coll',
    model = 'mode',
    multiplayerScenarioDescription = 'mply',
    object = 'obje',
    particleSystem = 'pctl',
    particle = 'part',
    physics = 'phys',
    placeHolder = 'plac',
    pointPhysics = 'pphy',
    preferencesNetworkGame = 'ngpr',
    projectile = 'proj',
    scenarioStructureBsp = 'sbsp',
    scenario = 'scnr',
    scenery = 'scen',
    shaderEnvironment = 'senv',
    shaderModel = 'soso',
    shaderTransparentChicagoExtended = 'scex',
    shaderTransparentChicago = 'schi',
    shaderTransparentGeneric = 'sotr',
    shaderTransparentGlass = 'sgla',
    shaderTransparentMeter = 'smet',
    shaderTransparentPlasma = 'spla',
    shaderTransparentWater = 'swat',
    shader = 'shdr',
    sky = 'sky ',
    soundEnvironment = 'snde',
    soundLooping = 'lsnd',
    soundScenery = 'ssce',
    sound = 'snd!',
    spheroid = 'boom',
    stringList = 'str#',
    tagCollection = 'tagc',
    uiWidgetCollection = 'Soul',
    uiWidgetDefinition = 'DeLa',
    unicodeStringList = 'ustr',
    unitHudInterface = 'unhi',
    unit = 'unit',
    vehicle = 'vehi',
    virtualKeyboard = 'vcky',
    weaponHudInterface = 'wphi',
    weapon = 'weap',
    weatherParticleSystem = 'rain',
    wind = 'wind'
}

-- Provide global object classes by default
local objectClasses = {
    biped = 0,
    vehicle = 1,
    weapon = 2,
    equipment = 3,
    garbage = 4,
    projectile = 5,
    scenery = 6,
    machine = 7,
    control = 8,
    lightFixture = 9,
    placeHolder = 10,
    soundScenery = 11
}

-- Camera types
local cameraTypes = {
    scripted = 1,       -- 22192
    firstPerson = 2,    -- 30400
    devcam = 3,         -- 30704
    thirdPerson = 4,    -- 31952
    deadCamera = 5      -- 23776
}


------------------------------------------------------------------------------
-- SAPP API bindings
------------------------------------------------------------------------------

if (api_version) then
    -- Create and bind Chimera functions to the ones in SAPP

    --- Return the memory address of a tag given tag id or type and path
    ---@param tag string | number
    ---@param path string
    ---@return number
    function get_tag(tag, path)
        if (not path) then
            return lookup_tag(tag)
        else
            return lookup_tag(tag, path)
        end
    end

    --- Execute a game command or script block
    ---@param command string
    function execute_script(command)
        return execute_command(command)
    end

    --- Return the address of the object memory given object id
    ---@param objectId number
    ---@return number
    function get_object(objectId)
        if (objectId) then
            local object_memory = get_object_memory(objectId)
            if (object_memory ~= 0) then
                return object_memory
            end
        end
        return nil
    end

    --- Delete an object given object id
    ---@param objectId number
    function delete_object(objectId)
        destroy_object(objectId)
    end

    --- Prints text into console
    ---@param message string
    function console_out(message)
        cprint(message)
    end

    print('Chimera API functions are available now with LuaBlam!')
end


------------------------------------------------------------------------------
-- Utilities
------------------------------------------------------------------------------

--- Return the type of a tag given tag address
---@param tagAddress number
---@return string
local function getTagClass(tagAddress)
    if (tagAddress) then
        local tagClass = ''
        for i=0, 3 do
            local byte = read_byte(tagAddress + i)
            tagClass = string.char(byte) .. tagClass
        end
        return tagClass
    else
        return nil
    end
end

--- Return the id of a tag given tag type and tag path
---@param tagAddress number
---@return number
local function getTagId(tagAddress)
    if (tagAddress and tagAddress ~= 0) then
        local tagId = tagAddress + 0xC
        return read_dword(tagId)
    end
    return nil
end

--- Return the tag path given tag id
---@param tagAddress number
---@return string
local function getTagPath(tagAddress)
    local tagPathAddress = read_dword(tagAddress + 0x10)
    return read_string(tagPathAddress)
end

--- Return the current existing objects in the current map, ONLY WORKS FOR CHIMERA!!!
---@return table
local function getObjects()
    local currentObjectsList = {}
    for i = 0, 2047 do
        if (get_object(i)) then
            currentObjectsList[#currentObjectsList + 1] = i
        end
    end
    return currentObjectsList
end

--- Return the string of a unicode string given address
---@param address number
---@return string
local function readUnicodeString(address)
    local stringAddress = read_dword(address)
    local length = stringAddress / 2
    local output = ''
    for i = 1, length do
        local char = read_string(stringAddress + (i-1) * 0x2)
        if (char == '') then
            break
        end
        output = output .. char
    end
    return output
end

--- Writes a unicode string in a given address
---@param address number
---@param newString string
local function writeUnicodeString(address, newString)
    local stringAddress = read_dword(address)
    for i = 1, #newString do
        write_string(stringAddress + (i-1) * 0x2, newString:sub(i,i))
        if (i == #newString) then
            write_byte(stringAddress + #newString * 0x2, 0x0)
        end
    end
end

--- Return the address of a tag given tag path (or id) and tag type
---@param tag string | number
---@param class string
---@return number
local function getTag(tag, class)
    if (type(tag) == 'number') then
        local tagAddress = get_tag(tag)
        if (tagAddress) then
            local tagClass = luablam.getTagClass(tagAddress)
            if (tagClass == class) then
                return tagAddress
            end
        end
        return nil
    else
        return get_tag(class, tag)
    end
end

-- Convert bits into boolean values
-- Writing true or false is equal to 1 or 0 but not when reading
---@param bit number
---@return boolean
local function b2b(bit)
    if (bit == 1) then
        return true
    end
    return false
end


------------------------------------------------------------------------------
-- Objects data binding
------------------------------------------------------------------------------

-- Data types operations
local dataOperations = {
    bit = {read_bit, write_bit},
    byte = {read_byte, write_byte},
    short = {read_short, write_short},
    word = {read_word, write_word},
    int = {read_int, write_int},
    dword = {read_dword, write_dword},
    float = {read_float, write_float},
    string = {read_string, write_string},
    ustring = {readUnicodeString, writeUnicodeString}
}

-- Magic luablam metatable
local dataBindingMetaTable = {
    __newindex = function(object, property, value)
        local propertyData = object.structure[property]
        if (propertyData) then
            local dataType = propertyData.type
            local operation = dataOperations[dataType]
            if (dataType == 'bit') then
                local bitLevel = propertyData.bitLevel
                operation[2](object.address + propertyData.offset, bitLevel, value)
            elseif (dataType == 'list') then
                operation = dataOperations[propertyData.elementsType]
                local listCount = read_byte(object.address + propertyData.offset - 0x4)
                local listAddress = read_dword(object.address + propertyData.offset)
                for i = 1, listCount do
                    if (value[i] ~= nil) then
                        operation[2](listAddress + 0xC + propertyData.jump * (i-1), value[i])
                    else
                        if (i > #value) then
                            break
                        end
                    end
                end
            elseif (dataType == 'table') then
                local elementsCount = read_byte(object.address + propertyData.offset - 0x4)
                local firstElement = read_dword(object.address + propertyData.offset)
                for i=1, elementsCount do
                    local elementAddress = firstElement + (i-1) * propertyData.jump
                    if (value[i] ~= nil) then
                        for k,v in pairs(value[i]) do
                            local fieldData = propertyData.rows[k]
                            if (fieldData ~= nil) then
                                operation = dataOperations[fieldData.type]
                                if (fieldData.type == 'bit') then
                                    operation[2](elementAddress + fieldData.offset, fieldData.bitLevel, v)
                                else
                                    operation[2](elementAddress + fieldData.offset, v)
                                end
                            end
                        end
                    else
                        if (i > #value) then
                            break
                        end
                    end
                end
            else
                operation[2](object.address + propertyData.offset, value)
            end
        else
            error("Cannot write into a invalid property '" .. property .. "'")
        end
    end,
    __index = function(object, property)
        local objectStructure = object.structure
        
        local propertyData = objectStructure[property]

        if (propertyData) then
            local dataType = propertyData.type
            local operation = dataOperations[dataType]
            if (dataType == 'bit') then
                local bitLevel = propertyData.bitLevel
                return b2b(operation[1](object.address + propertyData.offset, bitLevel))
            elseif (dataType == 'list') then
                operation = dataOperations[propertyData.elementsType]
                local listCount = read_byte(object.address + propertyData.offset - 0x4)
                local listAddress = read_dword(object.address + propertyData.offset)
                local list = {}
                for i = 1, listCount do
                    list[i] = operation[1](listAddress + 0xC + propertyData.jump * (i-1))
                end
                return list
            elseif (dataType == 'table') then
                local table = {}
                local elementsCount = read_byte(object.address + propertyData.offset - 0x4)
                local firstElement = read_dword(object.address + propertyData.offset)
                for i=1, elementsCount do
                    local elementAddress = firstElement + (i-1) * propertyData.jump
                    table[i] = {}
                    for k,v in pairs(propertyData.rows) do
                        operation = dataOperations[v.type]
                        if (v.type == 'bit') then
                            table[i][k] = b2b(operation[1](elementAddress + v.offset, v.bitLevel))
                        else
                            table[i][k] = operation[1](elementAddress + v.offset)
                        end
                    end
                end

                return table
            else
                return operation[1](object.address + propertyData.offset)
            end
        else
            error("Cannot read from a invalid property '" .. property .. "'")
        end
    end
}


------------------------------------------------------------------------------
-- Object functions
------------------------------------------------------------------------------

-- Remove unused properties for game execution
-- NOTE: DO NOT REMOVE THIS, it will be usefull...
---@param object table
local function cleanObject(object)
    --[[
    for k, v in pairs(object) do
        if (k ~= 'address' and k ~= 'structure') then
            object[k] = nil
        end
    end
    ]]
end

-- Return a dump of a given LuaBlam object
---@param object table
---@return table
local function dumpObject(object)
    local dump = {}
    for k, v in pairs(object.structure) do
        dump[k] = object[k]
    end
    return dump
end


------------------------------------------------------------------------------
-- Object structures
------------------------------------------------------------------------------

-- Return a extended parent structure with another given structure
---@param parent table
---@param structure table
---@return table
local function extendStructure(parent, structure)
    local extendedStructure = {}
    for k,v in pairs(parent) do
        extendedStructure[k] = v
    end
    for k,v in pairs(structure) do
        extendedStructure[k] = v
    end
    return extendedStructure
end

-- ObjectClass structure
local objectStructure = {
    tagId = {type = 'dword', offset = 0x0},
    hasCollision = {type = 'bit', offset = 0x10, bitLevel = 0},
    isOnGround = {type = 'bit', offset = 0x10, bitLevel = 1},
    ignoreGravity = {type = 'bit', offset = 0x10, bitLevel = 2},
    isInWater = {type = 'bit', offset = 0x10, bitLevel = 3},
    isStationary = {type = 'bit', offset = 0x10, bitLevel = 5},
    dynamicShading = {type = 'bit', offset = 0x10, bitLevel = 14},
    isNotCastingShadow = {type = 'bit', offset = 0x10, bitLevel = 18},
    frozen = {type = 'bit', offset = 0x10, bitLevel = 20},
    isOutSideMap = {type = 'bit', offset = 0x10, bitLevel = 21},
    isCollideable = {type = 'bit', offset = 0x10, bitLevel = 24},
    model = {type = 'dword', offset = 0x34},
    health = {type = 'float', offset = 0xE0},
    shield = {type = 'float', offset = 0xE4},
    redA = {type = 'float', offset = 0x1B8},
    greenA = {type = 'float', offset = 0x1BC},
    blueA = {type = 'float', offset = 0x1C0},
    x = {type = 'float', offset = 0x5C},
    y = {type = 'float', offset = 0x60},
    z = {type = 'float', offset = 0x64},
    xVel = {type = 'float', offset = 0x68},
    yVel = {type = 'float', offset = 0x6C},
    zVel = {type = 'float', offset = 0x70},
    pitch = {type = 'float', offset = 0x74},
    yaw = {type = 'float', offset = 0x78},
    roll = {type = 'float', offset = 0x7C},
    xScale = {type = 'float', offset = 0x80},
    yScale = {type = 'float', offset = 0x84},
    zScale = {type = 'float', offset = 0x88},
    pitchVel = {type = 'float', offset = 0x8C},
    yawVel = {type = 'float', offset = 0x90},
    rollVel = {type = 'float', offset = 0x94},
    type = {type = 'word', offset = 0xB4},
    animationTagId = {type = 'dword', offset = 0xCC},
    animation = {type = 'word', offset = 0xD0},
    animationFrame = {type = 'word', offset = 0xD2},
    weapon = {type = 'dword', offset = 0x11E},
    parent = {type = 'dword', offset = 0x122},
    regionPermutation1 = {type = 'byte', offset = 0x180},
    regionPermutation2 = {type = 'byte', offset = 0x181},
    regionPermutation3 = {type = 'byte', offset = 0x182},
    regionPermutation4 = {type = 'byte', offset = 0x183},
    regionPermutation5 = {type = 'byte', offset = 0x184},
    regionPermutation6 = {type = 'byte', offset = 0x185},
    regionPermutation7 = {type = 'byte', offset = 0x186},
    regionPermutation8 = {type = 'byte', offset = 0x187}
}

-- Biped structure (extends object structure)
local bipedStructure = extendStructure(objectStructure, {
    invisible = {type = 'bit', offset = 0x204, bitLevel = 4},
    noDropItems = {type = 'bit', offset = 0x204, bitLevel = 20},
    ignoreCollision = {type = 'bit', offset = 0x4CC, bitLevel = 3},
    flashlight = {type = 'bit', offset = 0x204, bitLevel = 19},
    cameraX = {type = 'float', offset = 0x230},
    cameraY = {type = 'float', offset = 0x234},
    cameraZ = {type = 'float', offset = 0x238},
    crouchHold = {type = 'bit', offset = 0x208, bitLevel = 0},
    jumpHold = {type = 'bit', offset = 0x208, bitLevel = 1},
    actionKeyHold = {type = 'bit', offset = 0x208, bitLevel = 14},
    actionKey = {type = 'bit', offset = 0x208, bitLevel = 6},
    meleeKey = {type = 'bit', offset = 0x208, bitLevel = 7},
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
})

-- Tag data header structure
local tagDataHeaderStructure = {
    array = {type = 'dword', offset = 0x0},
    scenario = {type = 'dword', offset = 0x4},
    count = {type = 'dword', offset = 0xC}
}

-- Tag structure
local tagStructure = {
    class = {type = 'dword', offset = 0x0},
    id = {type = 'dword', offset = 0xC},
    path = {type = 'string', offset = 0x10},
    _data = {type = 'dword', offset = 0x14},
    indexed = {type = 'dword', offset = 0x18}
}

-- tagCollection structure
local tagCollectionStructure = {
    count = {type = 'byte', offset = 0x0},
    tagList = {type = 'list', offset = 0x4, elementsType = 'dword', jump = 0x10}
}

-- UnicodeStringList structure
local unicodeStringListStructure = {
    count = {type = 'byte', offset = 0x0},
    stringList = {type = 'list', offset = 0x4, elementsType = 'ustring', jump = 0x14}
}

-- UI Widget Definition structure
local uiWidgetDefinitionStructure = {
    type = {type = 'word', offset = 0x0},
    controllerIndex = {type = 'word', offset = 0x2},
    name = {type = 'string', offset = 0x4},
    boundsY = {type = 'short', offset = 0x24},
    boundsX = {type = 'short', offset = 0x26},
    height = {type = 'short', offset = 0x28},
    width = {type = 'short', offset = 0x2A},
    backgroundBitmap = {type = 'word', offset = 0x44},
    eventType = {type = 'byte', offset = 0x03F0},
    tagReference = {type = 'word', offset = 0x400},
    childWidgetsCount = {type = 'dword', offset = 0x03E0},
    childWidgetsList = {type = 'list', offset = 0x03E4, elementsType = 'dword', jump = 0x50}
}

-- tagCollection structure
local uiWidgetCollectionStructure = {
    count = {type = 'byte', offset = 0x0},
    tagList = {type = 'list', offset = 0x4, elementsType = 'dword', jump = 0x10}
}

-- Weapon HUD Interface structure
local weaponHudInterfaceStructure = {
    crosshairs = {type = 'word', offset = 0x84},
    defaultBlue = {type = 'byte', offset = 0x208},
    defaultGreen = {type = 'byte', offset = 0x209},
    defaultRed = {type = 'byte', offset = 0x20A},
    defaultAlpha = {type = 'byte', offset = 0x20B},
    sequenceIndex = {type = 'short', offset = 0x22A}
}

-- Scenario structure
local scenarioStructure = {
    sceneryPaletteCount = {type = 'byte', offset = 0x021C},
    sceneryPaletteList = {type = 'list', offset = 0x0220, elementsType = 'dword', jump = 0x30},
    spawnLocationCount = {type = 'byte', offset = 0x354},
    spawnLocationList = { 
        type = 'table',
        offset = 0x358,
        jump = 0x34,
        rows = {
            x = {type = 'float', offset = 0x0},
            y = {type = 'float', offset = 0x4},
            z = {type = 'float', offset = 0x8},
            rotation = {type = 'float', offset = 0xC},
            teamIndex = {type = 'byte', offset = 0x10},
            bspIndex = {type = 'short', offset = 0x12},
            type = {type = 'byte', offset = 0x14}
        }
    },
    vehicleLocationCount = {type = 'byte', offset = 0x240},
    vehicleLocationList = {
        type = 'table',
        offset = 0x244,
        jump = 0x78,
        rows = {
            type = {type = 'word', offset = 0x0},
            nameIndex = {type = 'word', offset = 0x2},
            x = {type = 'float', offset = 0x8},
            y = {type = 'float', offset = 0xC},
            z = {type = 'float', offset = 0x10},
            yaw = {type = 'float', offset = 0x14},
            pitch = {type = 'float', offset = 0x18},
            roll = {type = 'float', offset = 0x1C}
        }
    }
}

-- Scenery structure
local sceneryStructure = {
    model = {type = 'word', offset = 0x28 + 0xC},
    modifierShader = {type = 'word', offset = 0x90 + 0xC}
}

-- Collision Model structure
local collisionGeometryStructure = {
    vertexCount = {type = 'byte', offset = 0x408},
    vertexList = {
        type = 'table',
        offset = 0x40C,
        jump = 0x10,
        rows = {
            x = {type = 'float', offset = 0x0},
            y = {type = 'float', offset = 0x4},
            z = {type = 'float', offset = 0x8},
        }
    },
}

-- Model Animation structure
local modelAnimationsStructure = {
    fpAnimationCount = {type = 'byte', offset = 0x90},
    fpAnimationList = {type = 'list', offset = 0x94, elementsType = 'byte', jump = 0x2},
    animationCount = {type = 'byte', offset = 0x74},
    animationList = {
        type = 'table',
        offset = 0x78,
        jump = 0xB4,
        rows = {
            name = {type = 'string', offset = 0x0},
            type = {type = 'word', offset = 0x20},
            frameCount = {type = 'byte', offset = 0x22},
            nextAnimation = {type = 'byte', offset = 0x38},
            sound = {type = 'byte', offset = 0x3C}
        }
    }
}

-- Weapon structure
local weaponStructure = {
    model = {type = 'dword', offset = 0x34}
}

-- Model structure
local modelStructure = {
    nodeCount = {type = 'dword', offset = 0xB8},
    nodeList = {
        type = 'table',
        offset = 0xBC,
        jump = 0x9C,
        rows = {
            x = {type = 'float', offset = 0x28},
            y = {type = 'float', offset = 0x2C},
            z = {type = 'float', offset = 0x30}
        }
    },
    regionCount = {type = 'dword', offset = 0xC4},
    regionList = {
        type = 'table',
        offset = 0xC8,
        jump = 76,
        rows = {
            permutationCount = {type = 'dword', offset = 0x40}
        }
    }
}


------------------------------------------------------------------------------
-- Object classes
------------------------------------------------------------------------------

---@class ObjectClass
---@field address number
---@field tagId number Object tag ID
---@field hasCollision boolean Check if object has or has not collision
---@field isOnGround boolean Is the object touching ground
---@field ignoreGravity boolean Make object to ignore gravity
---@field isInWater boolean Is the object touching on water
---@field dynamicShading boolean Enable disable dynamic shading for lightmaps
---@field isNotCastingShadow boolean Enable/disable object shadow casting
---@field frozen boolean Freeze/unfreeze object existence
---@field isOutSideMap boolean Is object outside/inside bsp
---@field isCollideable boolean Enable/disable object shadow casting
---@field model number Gbxmodel tag ID
---@field health number Current health of the object
---@field shield number Current shield of the object
---@field redA number Red color channel for A modifier
---@field greenA number Green color channel for A modifier
---@field blueA number Blue color channel for A modifier
---@field x number Current position of the object on X axis
---@field y number Current position of the object on Y axis
---@field z number Current position of the object on Z axis
---@field xVel number Current velocity of the object on X axis
---@field yVel number Current velocity of the object on Y axis
---@field zVel number Current velocity of the object on Z axis
---@field pitch number Current rotation of the object on pitch
---@field yaw number Current rotation of the object on yaw
---@field roll number Current rotation of the object on roll
---@field xScale number PROVIDE DESCRIPTION
---@field yScale number PROVIDE DESCRIPTION
---@field zScale number PROVIDE DESCRIPTION
---@field yawVel number Current velocity of the object in yaw
---@field pitchVel number Current velocity of the object in pitch
---@field rollVel number Current velocity of the object in roll
---@field type number Object type
---@field animationTagId number Current animation tag ID
---@field animation number Current animation index
---@field animationFrame number Current animation frame
---@field weapon number Current weapon tag ID
---@field parent number Parent object id
---@field regionPermutation1 number
---@field regionPermutation2 number
---@field regionPermutation3 number
---@field regionPermutation4 number
---@field regionPermutation5 number
---@field regionPermutation6 number
---@field regionPermutation7 number
---@field regionPermutation8 number
local objectClass = {}

function objectClass.new(address)
    local object = {}

    -- Legacy values
    object.address = address
    object.structure = objectStructure

    return object
end

---@class bipedClass : ObjectClass
---@field invisible boolean Biped invisible state
---@field noDropItems boolean Biped ability to drop items at dead
---@field ignoreCollision boolean Does the biped ignore the collision?
---@field flashlight boolean Does the biped have the flashlight enabled?
---@field cameraX number Current position of the biped  X axis
---@field cameraY number Current position of the biped  Y axis
---@field cameraZ number Current position of the biped  Z axis
---@field crouchHold boolean Biped is holding crouch action
---@field jumpHold boolean Biped is holding jump action
---@field actionKeyHold boolean Biped is holding action key
---@field actionKey boolean Biped pressed action key
---@field meleeKey boolean Biped pressed melee key
---@field reloadKey boolean Biped pressed reload key
---@field weaponPTH boolean Biped is holding primary weapon trigger
---@field weaponSTH boolean Biped is holding secondary weapon trigger
---@field flashlightKey boolean Biped pressed flashlight key
---@field grenadeHold boolean Biped is holding grenade action
---@field crouch number Is biped crouch
---@field shooting number Is biped shooting, 0 when not, 1 when shooting
---@field weaponSlot number Current biped weapon slot
---@field zoomLevel number Current biped weapon zoom level, 0xFF when no zoom, up to 255 when zoomed
---@field invisibleScale number Opacity amount of biped invisiblity
---@field primaryNades number Primary grenades count
---@field secondaryNades number Secondary grenades count
local bipedClass = {}

function bipedClass.new(address)
    -- Create object "instance"
    ---@class bipedObject
    local biped = {}

    -- Legacy values
    biped.address = address
    biped.structure = bipedStructure

    return biped
end

---@class tagClass
---@field class number Type of the tag
---@field id number Tag ID
---@field path string Path of the tag
---@field indexed boolean Is the tag indexed?
local tagClass = {}

function tagClass.new(address)
    -- Create tag "instance"
    local tag = {}

    -- Legacy values
    tag.address = address
    tag.structure = tagStructure

    return tag
end

---@class tagCollectionClass
---@field count number Number of tags in the collection
---@field tagList table List of tags
local tagCollectionClass = {}

function tagCollectionClass.new(address)
    -- Create object "instance"
    local tagCollection = {}

    -- Legacy values
    tagCollection.address = address
    tagCollection.structure = tagCollectionStructure

    return tagCollection
end

---@class unicodeStringListClass
---@field count number Number of unicode strings
---@field stringList table List of unicode strings
local unicodeStringListClass = {}

function unicodeStringListClass.new(address)
    -- Create object "instance"
    local unicodeStringList = {}

    -- Legacy values
    unicodeStringList.address = address
    unicodeStringList.structure = unicodeStringListStructure

    -- Mockup object properties for IDE
    unicodeStringList.count = 0xFF
    unicodeStringList.stringList = {}
    return unicodeStringList
end

---@class uiWidgetDefinitionClass
---@field type number Type of widget
---@field controllerIndex number Index of the player controller
---@field name string Name of the widget
---@field boundsY number Top bound of the widget
---@field boundsX number Left bound of the widget
---@field height number Bottom bound of the widget
---@field width number Right bound of the widget
---@field backgroundBitmap number Tag ID of the background bitmap
---@field eventType number
---@field tagReference number
---@field childWidgetsCount number Number of child widgets
---@field childWidgetsList table tag ID list of the child widgets
local uiWidgetDefinitionClass = {}

function uiWidgetDefinitionClass.new(address)
    -- Create object "instance"
    local uiWidgetDefinition = {}

    -- Legacy values
    uiWidgetDefinition.address = address
    uiWidgetDefinition.structure = uiWidgetDefinitionStructure

    return uiWidgetDefinition
end

---@class uiWidgetCollectionClass
---@field count number Number of widgets in the collection
---@field tagList table Tag ID list of the widgets
local uiWidgetCollectionClass = {}

function uiWidgetCollectionClass.new(address)
    -- Create object "instance"
    local uiWidgetCollection = {}

    -- Legacy values
    uiWidgetCollection.address = address
    uiWidgetCollection.structure = uiWidgetCollectionStructure

    return uiWidgetCollection
end

---@class weaponHudInterfaceClass
---@field crosshairs number
---@field defaultBlue number
---@field defaultGreen number
---@field defaultRed number
---@field defaultAlpha number
---@field sequenceIndex number
local weaponHudInterfaceClass = {}

function weaponHudInterfaceClass.new(address)
    -- Create object "instance"
    local weaponHudInterface = {}
    
    -- Legacy values
    weaponHudInterface.address = address
    weaponHudInterface.structure = weaponHudInterfaceStructure

    return weaponHudInterface
end

---@class scenerioClass
---@field sceneryPaletteCount number Number of sceneries in the scenery palette
---@field sceneryPaletteList table Tag ID list of scenerys in the scenery palette
---@field spawnLocationCount number Number of spawns in the scenario
---@field spawnLocationList table List of spawns in the scenario
---@field vehicleLocationCount number Number of vehicles locations in the scenario
---@field vehicleLocationList table List of vehicles locations in the scenario
local scenarioClass = {}

function scenarioClass.new(address)
    -- Create object "instance"
    local scenario = {}
    
    -- Legacy values
    scenario.address = address
    scenario.structure = scenarioStructure

    return scenario
end

---@class sceneryClass
---@field model number
---@field modifierShader number
local sceneryClass = {}

function sceneryClass.new(address)
    -- Create object "instance"
    local scenery = {}
    
    -- Legacy values
    scenery.address = address
    scenery.structure = sceneryStructure

    return scenery
end

---@class collisionGeometryClass
---@field vertexCount number Number of vertex in the collision geometry
---@field vertexList table List of vertex in the collision geometry
local collisionGeometryClass = {}

function collisionGeometryClass.new(address)
    -- Create object "instance"
    local collisionGeometry = {}
    
    -- Legacy values
    collisionGeometry.address = address
    collisionGeometry.structure = collisionGeometryStructure

    return collisionGeometry
end

---@class modelAnimationsClass
---@field fpAnimationCount number Number of first-person animations
---@field fpAnimationList table List of first-person animations
---@field animationCount number Number of animations of the model
---@field animationList table List of animations of the model
local modelAnimationsClass = {}

function modelAnimationsClass.new(address)
    -- Create object "instance"
    local modelAnimations = {}
    
    -- Legacy values
    modelAnimations.address = address
    modelAnimations.structure = modelAnimationsStructure

    return modelAnimations
end

---@class weaponClass
---@param model number Tag ID of the weapon model
local weaponClass = {}

function weaponClass.new(address)
    -- Create object "instance"
    local weapon = {}
    
    -- Legacy values
    weapon.address = address
    weapon.structure = weaponStructure

    return weapon
end

---@class modelClass
---@param nodeCount number Number of nodes
---@param nodeList table List of the model nodes
---@param regionCount number Number of regions
---@param regionList table List of regions
local modelClass = {}

function modelClass.new(address)
    -- Create object "instance"
    local model = {}
    
    -- Legacy values
    model.address = address
    model.structure = modelStructure

    return model
end


------------------------------------------------------------------------------
-- LuaBlam globals
------------------------------------------------------------------------------

-- Add data tables to library
luablam.addressList = addressList
luablam.tagClasses = tagClasses
luablam.objectClasses = objectClasses
luablam.cameraTypes = cameraTypes

luablam.tagDataHeader = {}

function updateTagDataHeaderGlobal() 
    local headerData = {}

    headerData.address = addressList.tagDataHeader
    headerData.structure = tagDataHeaderStructure

    setmetatable(headerData, dataBindingMetaTable)

    luablam.tagDataHeader = luablam.dumpObject(headerData)
end

set_callback('map load', 'updateTagDataHeaderGlobal')


------------------------------------------------------------------------------
-- LuaBlam API
------------------------------------------------------------------------------

-- Add utilities to library
luablam.getTagClass = getTagClass
luablam.getTagId = getTagId
luablam.getTagPath = getTagPath
luablam.getObjects = getObjects
luablam.dumpObject = dumpObject

--- Returns the camera type
---@return number
function luablam.getCameraType()
    local camera = read_word(addressList.cameraType)
    local cameraType = nil
    
    if (camera == 22192) then
        cameraType = 1
    elseif (camera == 30400) then
        cameraType = 2
    elseif (camera == 30704) then
        cameraType = 3
    elseif (camera == 21952) then
        cameraType = 4
    elseif (camera == 23776) then
        cameraType = 5
    end

    return cameraType
end

--- Create a ingame-object object from a given address
---@param address integer
---@return ObjectClass
function luablam.object(address)
    if (address and address ~= 0) then
        -- Generate a new object from class
        local newObject = objectClass.new(address)

        -- Set mechanisim to bind properties to memory
        setmetatable(newObject, dataBindingMetaTable)

        cleanObject(newObject)

        return newObject
    end
    return nil
end

--- Create a tag object from a given address
---@param address number
---@return tagClass
function luablam.tag(address)
    if (address and address ~= 0) then
        -- Generate a new object from class
        local newObject = tagClass.new(address)

        -- Set mechanisim to bind properties to memory
        setmetatable(newObject, dataBindingMetaTable)

        cleanObject(newObject)

        return newObject
    end
    return nil
end

--- Create a Biped object from a given address
---@param address number
---@return bipedClass
function luablam.biped(address)
    if (address and address ~= 0) then
        -- Generate a new object from class
        local newBiped = bipedClass.new(address)

        -- Set mechanisim to bind properties to memory
        setmetatable(newBiped, dataBindingMetaTable)

        cleanObject(newBiped)

        return newBiped
    end
    return nil
end

--- Create a Unicode String List object from a tag path or id
---@param tag string | number
---@return unicodeStringListClass
function luablam.unicodeStringList(tag)
    if (tag and tag ~= '') then
        local tagAddress = getTag(tag, tagClasses.unicodeStringList)
        if (tagAddress and tagAddress ~= 0) then
            local address = read_dword(tagAddress + 0x14)
            -- Generate a new object from class
            local newUnicodeStringList = unicodeStringListClass.new(address)

            -- Set mechanisim to bind properties to memory
            setmetatable(newUnicodeStringList, dataBindingMetaTable)

            cleanObject(newUnicodeStringList)

            return newUnicodeStringList
        end
    end
    return nil
end

--- Create a UI Widget Definition object from a tag path or id
---@param tag string | number
---@return uiWidgetDefinitionClass
function luablam.uiWidgetDefinition(tag)
    if (tag and tag ~= '') then
        local tagAddress = getTag(tag, tagClasses.uiWidgetDefinition)
        if (tagAddress and tagAddress ~= 0) then
            local address = read_dword(tagAddress + 0x14)
            -- Generate a new object from class
            local newUiWidgetDefinition = uiWidgetDefinitionClass.new(address)

            -- Set mechanisim to bind properties to memory
            setmetatable(newUiWidgetDefinition, dataBindingMetaTable)

            cleanObject(newUiWidgetDefinition)

            return newUiWidgetDefinition
        end
    end
    return nil
end

--- Create a UI Widget Collection object from a tag path or id
---@param tag string | number
---@return uiWidgetCollectionClass
function luablam.uiWidgetCollection(tag)
    if (tag and tag ~= '') then
        local tagAddress = getTag(tag, tagClasses.uiWidgetCollection)
        if (tagAddress and tagAddress ~= 0) then
            local address = read_dword(tagAddress + 0x14)
            -- Generate a new object from class
            local newUiWidgetCollection = uiWidgetCollectionClass.new(address)

            -- Set mechanisim to bind properties to memory
            setmetatable(newUiWidgetCollection, dataBindingMetaTable)

            cleanObject(newUiWidgetCollection)

            return newUiWidgetCollection
        end
    end
    return nil
end

--- Create a Tag Collection object from a tag path or id
---@param tag string | number
---@return tagCollectionClass
function luablam.tagCollection(tag)
    if (tag and tag ~= '') then
        local tagAddress = getTag(tag, tagClasses.tagCollection)
        if (tagAddress and tagAddress ~= 0) then
            local address = read_dword(tagAddress + 0x14)
            -- Generate a new object from class
            local newTagCollection = tagCollectionClass.new(address)

            -- Set mechanisim to bind properties to memory
            setmetatable(newTagCollection, dataBindingMetaTable)

            cleanObject(newTagCollection)

            return newTagCollection
        end
    end
    return nil
end

--- Create a Weapon HUD Interface object from a tag path or id
---@param tag string | number
---@return weaponHudInterfaceClass
function luablam.weaponHudInterface(tag)
    if (tag and tag ~= '') then
        local tagAddress = getTag(tag, tagClasses.weaponHudInterface)
        if (tagAddress and tagAddress ~= 0) then
            local address = read_dword(tagAddress + 0x14)
            -- Generate a new object from class
            local newWeaponHudInterface = weaponHudInterfaceClass.new(address)

            -- Set mechanisim to bind properties to memory
            setmetatable(newWeaponHudInterface, dataBindingMetaTable)

            cleanObject(newWeaponHudInterface)

            return newWeaponHudInterface
        end
    end
    return nil
end

--- Create a Scenario object from a tag path or id
---@return scenerioClass
function luablam.scenario()
    local address = read_dword(getTag(0, tagClasses.scenario) + 0x14)
    -- Generate a new object from class
    local newScenario = scenarioClass.new(address)

    -- Set mechanisim to bind properties to memory
    setmetatable(newScenario, dataBindingMetaTable)

    cleanObject(newScenario)

    return newScenario
end

--- Create a Scenery object from a tag path or id
---@param tag string | number
---@return sceneryClass
function luablam.scenery(tag)
    if (tag and tag ~= '') then
        local tagAddress = getTag(tag, tagClasses.scenery)
        if (tagAddress and tagAddress ~= 0) then
            local address = read_dword(tagAddress + 0x14)
            -- Generate a new object from class
            local newScenery = sceneryClass.new(address)

            -- Set mechanisim to bind properties to memory
            setmetatable(newScenery, dataBindingMetaTable)

            cleanObject(newScenery)

            return newScenery
        end
    end
    return nil
end

--- Create a Collision Geometry object from a tag path or id
---@param tag string | number
---@return collisionGeometryClass
function luablam.collisionGeometry(tag)
    if (tag and tag ~= '') then
        local tagAddress = getTag(tag, tagClasses.collisionGeometry)
        if (tagAddress and tagAddress ~= 0) then
            local address = read_dword(tagAddress + 0x14)
            -- Generate a new object from class
            local newCollisionGeometry = collisionGeometryClass.new(address)

            -- Set mechanisim to bind properties to memory
            setmetatable(newCollisionGeometry, dataBindingMetaTable)

            cleanObject(newCollisionGeometry)

            return newCollisionGeometry
        end
    end
    return nil
end

--- Create a Model Animation object from a tag path or id
---@param tag string | number
---@return modelAnimationsClass
function luablam.modelAnimations(tag)
    if (tag and tag ~= '') then
        local tagAddress = getTag(tag, tagClasses.modelAnimations)
        if (tagAddress and tagAddress ~= 0) then
            local address = read_dword(tagAddress + 0x14)
            -- Generate a new object from class
            local newModelAnimations = modelAnimationsClass.new(address)

            -- Set mechanisim to bind properties to memory
            setmetatable(newModelAnimations, dataBindingMetaTable)

            cleanObject(newModelAnimations)

            return newModelAnimations
        end
    end
    return nil
end

--- Create a Model Animation object from a tag path or id
---@param tag string | number
---@return weaponClass
function luablam.weapon(tag)
    if (tag and tag ~= '') then
        local tagAddress = getTag(tag, tagClasses.weapon)
        if (tagAddress and tagAddress ~= 0) then
            local address = read_dword(tagAddress + 0x14)
            -- Generate a new object from class
            local newweapon = weaponClass.new(address)

            -- Set mechanisim to bind properties to memory
            setmetatable(newweapon, dataBindingMetaTable)

            cleanObject(newweapon)

            return newweapon
        end
    end
    return nil
end

--- Create a Model Animation object from a tag path or id
---@param tag string | number
---@return modelClass
function luablam.model(tag)
    if (tag and tag ~= '') then
        local tagAddress = getTag(tag, tagClasses.model)
        if (tagAddress and tagAddress ~= 0) then
            local address = read_dword(tagAddress + 0x14)
            -- Generate a new object from class
            local newmodel = modelClass.new(address)

            -- Set mechanisim to bind properties to memory
            setmetatable(newModel, dataBindingMetaTable)

            cleanObject(newModel)

            return newModel
        end
    end
    return nil
end

------------------------------------------------------------------------------
-- LuaBlam 3.5 compatibility layer
------------------------------------------------------------------------------

local luablam35 = {}

-- Set compatibility layer version
luablam35.version = 3.5

-- LuaBlam old API binding
---@param class string
---@param param string | number
---@param properties table
---@return table | nil
function proccessRequestedObject(class, param, properties)
    local object = luablam[class](param)
    if (properties == nil) then
        return dumpObject(object)
    else
        for k,v in pairs(properties) do
            object[k] = v
        end
    end
end

---@param address number
---@param properties nil | table
---@return ObjectClass
function luablam35.object(address, properties)
    if (address and address ~= 0) then
        return proccessRequestedObject('object', address, properties)
    end
    return nil
end

---@param address number
---@param properties nil | table
---@return bipedClass
function luablam35.biped(address, properties)
    if (address and address ~= 0) then
        return proccessRequestedObject('biped', address, properties)
    end
    return nil
end

---@param address number
---@param properties nil | table
---@return uiWidgetDefinitionClass
function luablam35.uiWidgetDefinition(address, properties)
    if (address and address ~= 0) then
        local tagPath = luablam.getTagPath(address)
        return proccessRequestedObject('uiWidgetDefinition', tagPath, properties)
    end
    return nil
end

---@param address number
---@param properties nil | table
---@return weaponHudInterfaceClass
function luablam35.weaponHudInterface(address, properties)
    if (address and address ~= 0) then
        local tagPath = luablam.getTagPath(address)
        return proccessRequestedObject('weaponHudInterface', tagPath, properties)
    end
    return nil
end

---@param address number
---@param properties nil | table
---@return unicodeStringListClass
function luablam35.unicodeStringList(address, properties)
    if (address and address ~= 0) then
        local tagPath = luablam.getTagPath(address)
        return proccessRequestedObject('unicodeStringList', tagPath, properties)
    end
    return nil
end

---@param address number
---@param properties nil | table
---@return scenerioClass
function luablam35.scenario(address, properties)
    if (address and address ~= nil) then
        local tagPath = luablam.getTagPath(address)
        return proccessRequestedObject('scenario', tagPath, properties)
    end
end

---@param address number
---@param properties nil | table
---@return sceneryClass
function luablam35.scenery(address, properties)
    if (address and address ~= 0) then
        local tagPath = luablam.getTagPath(address)
        return proccessRequestedObject('scenery', tagPath, properties)
    end
    return nil
end

---@param address number
---@param properties nil | table
---@return collisionGeometryClass
function luablam35.collisionGeometry(address, properties)
    if (address and address ~= 0) then
        local tagPath = luablam.getTagPath(address)
        return proccessRequestedObject('collisionGeometry', tagPath, properties)
    end

    return nil
end

---@param address number
---@param properties nil | table
---@return modelAnimationsClass
function luablam35.modelAnimations(address, properties)
    if (address and address ~= 0) then
        local tagPath = luablam.getTagPath(address)
        return proccessRequestedObject('modelAnimations', tagPath, properties)
    end
    return nil
end

---@param address number
---@param properties nil | table
---@return tagCollectionClass
function luablam35.tagCollection(address, properties)
    if (address and address ~= 0) then
        local tagPath = luablam.getTagPath(address)
        return proccessRequestedObject('tagCollection', tagPath, properties)
    end
    return nil
end

-- Setups LuaBlam 3.5 API
---@return table
function luablam.compat35()
    --- Return the id of a tag given tag type and tag path
    ---@param tagClass string
    ---@param tagPath string
    ---@return number
    get_tag_id = function(tagClass, tagPath)
        local tagAddress = get_tag(tagClass, tagPath)
        if (tagAddress and tagAddress ~= 0) then
            return luablam.getTagId(tagAddress)
        end
        return nil
    end

    --- Return the simple id of a tag given tag type and tag path
    ---@param type string
    ---@param path string
    ---@return number
    get_simple_tag_id = function(type, path)
        local global_tag_address = get_tag(type, path)
        for tagId = 0, get_tags_count() - 1 do
            if (get_tag_path(tagId) == path) then
                return tagId
            end
        end
        return nil
    end

    --- Return the tag path given tag id
    ---@param tagId number
    ---@return string
    get_tag_path = function(tagId)
        local tagAddress = get_tag(tagId)
        if (tagAddress and tagAddress ~= 0) then
            return luablam.getTagPath(tagAddress)
        end
        return nil
    end

    --- Return the type of a tag given tag id
    ---@param tagId number
    ---@return string
    get_tag_type = function(tagId)
        local tagAddress = get_tag(tagId)
        if (tagAddress and tagAddress ~= 0) then
            return luablam.getTagClass(tagAddress)
        end
        return nil
    end

    --- Return the count of tags in the current map
    ---@return number
    get_tags_count = function()
        return luablam.tagDataHeader.count
    end

    --- Return the current existing objects in the current map
    ---@return table objectsList
    get_objects = function()
        return luablam.getObjects()
    end

    return luablam35
end

------------------------------------------------------------------------------

return luablam