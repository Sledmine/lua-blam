------------------------------------------------------------------------------
-- Blam library for Chimera/SAPP Lua scripting.
-- Authors: Sledmine
-- Version: 4.0
-- Improves memory handle and provides standard functions for scripting
------------------------------------------------------------------------------
local luablam = {}

-- Provide global tag classes by default
tagClasses = {
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
objectClasses = {
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

function read_unicode_string(address, length)
    local result_string = ''
    for i = 1, length / 2 do
        local char = read_string(address)
        if (char == '') then
            break
        end
        result_string = result_string .. char
        address = address + 0x2
    end
end

function write_unicode_string(address, length)
end

local dataOperations = {
    bit = {read_bit, write_bit},
    byte = {read_byte, write_byte},
    short = {read_short, write_short},
    word = {read_word, write_word},
    int = {read_int, write_int},
    dword = {read_dword, write_dword},
    string = {read_string, write_string},
    ustring = {read_unicode_string, write_unicode_string}
}

-- Convert bits into boolean values
-- Writing true or false is equal to 1 or 0 but not when reading
local function b2b(bit)
    if (bit == 1) then
        return true
    end
    return false
end

local dataBindingMetaTable = {
    __newindex = function(object, property, value)
        --console_out('WRITING data...')
        local propertyData = object.structure[property]
        if (propertyData) then
            local dataType = propertyData.type
            local operation = nil
            if (dataType == 'bit') then
                operation = dataOperations[dataType]
                local bitLevel = propertyData.bitLevel
                operation[2](object.address + propertyData.offset, bitLevel, value)
            else
                operation[2](object.address + propertyData.offset, value)
            end
        end
    end,
    __index = function(object, property, value)
        --console_out('READING data...')
        local objectStructure = object.structure
        
        local propertyData = objectStructure[property]

        if (propertyData) then
            local dataType = propertyData.type
            local operation = dataOperations[dataType]
            if (dataType == 'bit') then
                local bitLevel = propertyData.bitLevel
                return b2b(operation[1](object.address + propertyData.offset, bitLevel))
            elseif (dataType == 'array') then

            else
                return operation[1](object.address + propertyData.offset)
            end
        end
    end
}

-- Remove unused properties for game execution
function cleanObject(t)
    for k, v in pairs(t) do
        if (k ~= 'address' and k ~= 'structure') then
            t[k] = nil
        end
    end
end

-- Biped structure
local bipedStructure = {
    invisible = {type = 'bit', offset = 0x204, bitLevel = 4},
    noDropItems = {type = 'bit', offset = 0x204, bitlevel = 20},
    ignoreCollision = {type = 'bit', offset = 0x4CC, bitlevel = 3},
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

local bipedClass = {}
function bipedClass.create(address)
    -- Create object "instance"
    local biped = {}
    -- Legacy values
    biped.address = address
    biped.structure = bipedStructure

    -- Mockup object properties for IDE
    biped.invisible = false
    biped.ignoreCollision = false
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
    biped.weaponSTH = false
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
        setmetatable(newBiped, dataBindingMetaTable)

        cleanObject(newBiped)

        return newBiped
    end
    return nil
end

-- UnicodeStringList structure
local unicodeStringListStructure = {
    count = {type = 'byte', offset = 0x0},
    stringList = {
        jump = 0x14,
        {type = 'ustring', offset = 0x4}
    }
    --[[
        weapons = {
        {jump = 0x64},
        {type = 'byte', offset = 0x378, property = 'name'},
        {type = 'int', offset = 0x867, property = 'damage'}
    ]]
}

local unicodeStringListClass = {}
function unicodeStringListClass.create(address)
    -- Create object "instance"
    local unicodeStringList = {}
    -- Legacy values
    unicodeStringList.address = address
    unicodeStringList.structure = unicodeStringListStructure

    -- Mockup object properties for IDE
    unicodeStringList.count = 0
    unicodeStringList.stringList = {}
    return unicodeStringList
end

--- Create a Unicode String List object from a tag path
---@param tagPath string
function luablam.unicodeStringList(tagPath)
    if (tagPath and tagPath ~= '') then
        local tagAddress = get_tag(tagClasses.unicodeStringList, tagPath)
        if (tagAddress and tagAddress ~= 0) then
            local address = read_dword(tagAddress + 0x14)
            -- Generate a new object from class
            local newObject = unicodeStringListClass.create(address)

            -- Set mechanisim to bind properties to memory
            setmetatable(newObject, dataBindingMetaTable)

            cleanObject(newObject)

            return newObject
        end
    end
    return nil
end

return luablam
