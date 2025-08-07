------------------------------------------------------------------------------
-- Blam! library for Chimera/SAPP Lua scripting
-- Sledmine, JerryBrick
-- Easier memory handle and provides standard functions for scripting
------------------------------------------------------------------------------
local cos = math.cos
local sin = math.sin
local atan = math.atan
local pi = math.pi
math.atan2 = math.atan2 or function(y, x)
    return atan(y / x) + (x < 0 and pi or 0)
end
local atan2 = math.atan2
local sqrt = math.sqrt
local fmod = math.fmod
local rad = math.rad
local deg = math.deg

local blam = {_VERSION = "2.0.0-dev"}

blam.tag = {}

------------------------------------------------------------------------------
-- Useful functions for internal usage
------------------------------------------------------------------------------

-- From legacy glue library!
--- String or number to hex
local function tohex(s, upper)
    if type(s) == "number" then
        return (upper and "%08.8X" or "%08.8x"):format(s)
    end
    if upper then
        return (s:sub(".", function(c)
            return ("%02X"):format(c:byte())
        end))
    else
        return (s:gsub(".", function(c)
            return ("%02x"):format(c:byte())
        end))
    end
end

--- Hex to binary string
local function fromhex(s)
    if #s % 2 == 1 then
        return fromhex("0" .. s)
    end
    return (s:gsub("..", function(cc)
        return string.char(tonumber(cc, 16))
    end))
end

local function split(s, sep)
    if (sep == nil or sep == "") then
        return 1
    end
    local position, array = 0, {}
    for st, sp in function()
        return string.find(s, sep, position, true)
    end do
        table.insert(array, string.sub(s, position, st - 1))
        position = sp + 1
    end
    table.insert(array, string.sub(s, position))
    return array
end

local null = 0xFFFFFFFF

--- Get if given value equals a null value in game engine terms
---@param value any
---@return boolean
function blam.isNull(value)
    if value == 0xFF or value == 0xFFFF or value == null or value == nil then
        return true
    end
    return false
end
local isNull = blam.isNull

---Return if game instance is host
---@return boolean
function blam.isGameHost()
    return server_type == "local"
end

---Return if game instance is single player
---@return boolean
function blam.isGameSinglePlayer()
    return server_type == "none"
end

---Return if the game instance is running on a dedicated server or connected as a "network client"
---@return boolean
function blam.isGameDedicated()
    return server_type == "dedicated"
end

---Return if the game instance is a SAPP server
---@return boolean
function blam.isGameSAPP()
    return register_callback or server_type == "sapp"
end

------------------------------------------------------------------------------
-- Blam! engine data
------------------------------------------------------------------------------

---@alias tagId number

-- Engine address list
local addressList = {
    tagDataHeader = 0x40440000,
    cameraType = 0x00647498, -- from giraffe
    gamePaused = 0x004ACA79,
    gameOnMenus = 0x00622058,
    joystickInput = 0x64D998, -- from aLTis
    firstPerson = 0x40000EB8, -- from aLTis
    objectTable = 0x400506B4,
    deviceGroupsTable = 0x00816110,
    widgetsInstance = 0x6B401C,
    -- syncedNetworkObjects = 0x004F7FA2
    syncedNetworkObjects = 0x006226F0, -- pointer, from Vulpes
    screenResolution = 0x637CF0,
    currentWidgetIdAddress = 0x6B401C,
    cinematicGlobals = 0x0068c83c,
    hscGlobalsPointer = 0x0064bab0
}

-- Server side addresses adjustment
if blam.isGameSAPP() then
    addressList.deviceGroupsTable = 0x006E1C50
    addressList.objectTable = 0x4005062C
    addressList.syncedNetworkObjects = 0x00598020 -- not pointer cause cheat engine sucks
    addressList.cinematicGlobals = 0x005f506c
    addressList.hscGlobalsPointer = 0x005bd890
    addressList.hscGlobals = 0x6e144c
end

-- Tag groups values
---@enum tagGroup
local tagGroups = {
    actorVariant = "actv",
    actor = "actr",
    antenna = "ant!",
    biped = "bipd",
    bitmap = "bitm",
    cameraTrack = "trak",
    colorTable = "colo",
    continuousDamageEffect = "cdmg",
    contrail = "cont",
    damageEffect = "jpt!",
    decal = "deca",
    detailObjectCollection = "dobc",
    deviceControl = "ctrl",
    deviceLightFixture = "lifi",
    deviceMachine = "mach",
    device = "devi", -- ???
    device = "devc",
    dialogue = "udlg",
    effect = "effe",
    equipment = "eqip",
    flag = "flag",
    fog = "fog ",
    font = "font",
    garbage = "garb",
    gbxmodel = "mod2",
    globals = "matg",
    glow = "glw!",
    grenadeHudInterface = "grhi",
    hudGlobals = "hudg",
    hudMessageText = "hmt ",
    hudNumber = "hud#",
    itemCollection = "itmc",
    item = "item",
    lensFlare = "lens",
    lightVolume = "mgs2",
    light = "ligh",
    lightning = "elec",
    materialEffects = "foot",
    meter = "metr",
    modelAnimations = "antr",
    modelCollisiionGeometry = "coll",
    model = "mode",
    multiplayerScenarioDescription = "mply",
    object = "obje",
    particleSystem = "pctl",
    particle = "part",
    physics = "phys",
    placeholder = "plac",
    pointPhysics = "pphy",
    preferencesNetworkGame = "ngpr",
    projectile = "proj",
    scenarioStructureBsp = "sbsp",
    scenario = "scnr",
    scenery = "scen",
    shaderEnvironment = "senv",
    shaderModel = "soso",
    shaderTransparentChicagoExtended = "scex",
    shaderTransparentChicago = "schi",
    shaderTransparentGeneric = "sotr",
    shaderTransparentGlass = "sgla",
    shaderTransparentMeter = "smet",
    shaderTransparentPlasma = "spla",
    shaderTransparentWater = "swat",
    shader = "shdr",
    sky = "sky ",
    soundEnvironment = "snde",
    soundLooping = "lsnd",
    soundScenery = "ssce",
    sound = "snd!",
    spheroid = "boom",
    stringList = "str#",
    tagCollection = "tagc",
    uiWidgetCollection = "Soul",
    uiWidgetDefinition = "DeLa",
    unicodeStringList = "ustr",
    unitHudInterface = "unhi",
    unit = "unit",
    vehicle = "vehi",
    virtualKeyboard = "vcky",
    weaponHudInterface = "wphi",
    weapon = "weap",
    weatherParticleSystem = "rain",
    wind = "wind"
}

-- Blam object classes values
---@enum objectClasses
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
---@enum cameraTypes
local cameraTypes = {
    scripted = 1, -- 22192
    firstPerson = 2, -- 30400
    devcam = 3, -- 30704
    thirdPerson = 4, -- 31952
    deadCamera = 5 -- 23776
}

-- Netgame flag classes
---@enum netgameFlagClasses
local netgameFlagClasses = {
    ctfFlag = 0,
    ctfVehicle = 1,
    ballSpawn = 2,
    raceTrack = 3,
    raceVehicle = 4,
    vegasBank = 5,
    teleportFrom = 6,
    teleportTo = 7,
    hillFlag = 8
}

-- Game type classes
---@enum gameTypeClasses
local gameTypeClasses = {
    none = 0,
    ctf = 1,
    slayer = 2,
    oddball = 3,
    koth = 4,
    race = 5,
    terminator = 6,
    stub = 7,
    ignored1 = 8,
    ignored2 = 9,
    ignored3 = 10,
    ignored4 = 11,
    allGames = 12,
    allExceptCtf = 13,
    allExceptRaceCtf = 14
}

-- Multiplayer team classes
---@enum multiplayerTeamClasses
local multiplayerTeamClasses = {red = 0, blue = 1}

-- Unit team classes
---@enum unitTeamClasses
local unitTeamClasses = {
    defaultByUnit = 0,
    player = 1,
    human = 2,
    covenant = 3,
    flood = 4,
    sentinel = 5,
    unused6 = 6,
    unused7 = 7,
    unused8 = 8,
    unused9 = 9
}

-- Object network role classes
---@enum objectNetworkRoleClasses
local objectNetworkRoleClasses = {
    master = 0,
    puppet = 1,
    locallyControlledPuppet = 2,
    localOnly = 3
}

-- Standard console colors
local consoleColors = {
    success = {1, 0.235, 0.82, 0},
    warning = {1, 0.94, 0.75, 0.098},
    error = {1, 1, 0.2, 0.2},
    unknown = {1, 0.66, 0.66, 0.66}
}

-- Offset input from the joystick game data
local joystickInputs = {
    -- No zero values also pressed time until maxmimum byte size
    button1 = 0, -- Triangle
    button2 = 1, -- Circle
    button3 = 2, -- Cross
    button4 = 3, -- Square
    leftBumper = 4,
    rightBumper = 5,
    leftTrigger = 6,
    rightTrigger = 7,
    backButton = 8,
    startButton = 9,
    leftStick = 10,
    rightStick = 11,
    rightStick2 = 12,
    -- TODO Add joys axis
    leftStickUp = 30,
    leftStickDown = 32,
    rightStickUp = 34,
    rightStickDown = 36,
    triggers = 38,
    -- Multiple values on the same offset, check dPadValues table
    dPad = 96,
    -- Non zero values
    dPadUp = 100,
    dPadDown = 104,
    dPadLeft = 106,
    dPadRight = 102,
    dPadUpRight = 101,
    dPadDownRight = 103,
    dPadUpLeft = 107,
    dPadDownLeft = 105
}

-- Values for the possible dPad values from the joystick inputs
local dPadValues = {
    noButton = 1020,
    upRight = 766,
    downRight = 768,
    upLeft = 772,
    downLeft = 770,
    left = 771,
    right = 767,
    down = 769,
    up = 765
}

local engineConstants = {defaultNetworkObjectsCount = 509}

-- Global variables

---	This is the current gametype that is running. If no gametype is running, this will be set to nil
---, possible values are: ctf, slayer, oddball, king, race.
---@type string | nil
gametype = gametype
---This is the index of the local player. This is a value between 0 and 15, this value does not
---match with player index in the server and is not instantly assigned after joining.
---@type number | nil
local_player_index = local_player_index
---This is the name of the current loaded map.
---@type string
map = map
---Return if the map has protected tags data.
---@type boolean
map_is_protected = map_is_protected
---This is the name of the script. If the script is a global script, it will be defined as the
---filename of the script. Otherwise, it will be the name of the map.
---@type string
script_name = script_name
---This is the script type, possible values are global or map.
---@type string
script_type = script_type
---@type "none" | "local" | "dedicated" | "sapp"
---@diagnostic disable-next-line: assign-type-mismatch
server_type = server_type or "none"
---Return whether or not the script is sandboxed. See Sandoboxed Scripts for more information.
---@deprecated
---@type boolean
sandboxed = sandboxed ---@diagnostic disable-line: deprecated

local backupFunctions = {}

backupFunctions.console_is_open = _G.console_is_open
backupFunctions.console_out = _G.console_out
backupFunctions.execute_script = _G.execute_script
backupFunctions.get_global = _G.get_global
-- backupFunctions.set_global = _G.set_global
backupFunctions.get_tag = _G.get_tag
backupFunctions.set_callback = _G.set_callback
backupFunctions.set_timer = _G.set_timer
backupFunctions.stop_timer = _G.stop_timer

backupFunctions.spawn_object = _G.spawn_object
backupFunctions.delete_object = _G.delete_object
backupFunctions.get_object = _G.get_object
backupFunctions.get_dynamic_player = _G.get_dynamic_player

backupFunctions.hud_message = _G.hud_message

backupFunctions.create_directory = _G.create_directory
backupFunctions.remove_directory = _G.remove_directory
backupFunctions.directory_exists = _G.directory_exists
backupFunctions.list_directory = _G.list_directory
backupFunctions.write_file = _G.write_file
backupFunctions.read_file = _G.read_file
backupFunctions.delete_file = _G.delete_file
backupFunctions.file_exists = _G.file_exists

------------------------------------------------------------------------------
-- Chimera API auto completion
-- EmmyLua autocompletion for some functions!
-- Functions below do not have a real implementation and are not supossed to be imported
------------------------------------------------------------------------------

---Attempt to spawn an object given tag class, tag path and coordinates.
---Given a tag id is also accepted.
---@overload fun(tagId: number, x: number, y: number, z: number):number
---@param tagClass tagClasses Type of the tag to spawn
---@param tagPath string Path of object to spawn
---@param x number
---@param y number
---@param z number
---@return number? objectId
function spawn_object(tagClass, tagPath, x, y, z)
    if type(tagClass) == "number" then
        local x = tagPath --[[@as number]]
        local y = x
        local z = y
        local tag = blam.getTagEntry(tagClass)
        if tag then
            return backupFunctions.spawn_object(tag.class, tag.path, x, y, z)
        end
    end
    return backupFunctions.spawn_object(tagClass, tagPath, x, y, z)
end

---Attempt to get the address of a player unit object given player index, returning nil on failure.<br>
---If no argument is given, the address to the local player’s unit object is returned, instead.
---@param playerIndex? number
---@return number? objectAddress
function get_dynamic_player(playerIndex)
end

get_dynamic_player = backupFunctions.get_dynamic_player

------------------------------------------------------------------------------
-- SAPP API bindings
------------------------------------------------------------------------------

---Write content to a text file given file path
---@param path string Path to the file to write
---@param content string Content to write into the file
---@return boolean, string? result True if successful otherwise nil, error
function write_file(path, content)
    local file, error = io.open(path, "w")
    if (not file) then
        return false, error
    end
    local success, err = file:write(content)
    file:close()
    if (not success) then
        os.remove(path)
        return false, err
    else
        return true
    end
end

---Read the contents from a file given file path.
---@param path string Path to the file to read
---@return boolean, string? content string if successful otherwise nil, error
function read_file(path)
    local file, error = io.open(path, "r")
    if (not file) then
        return false, error
    end
    local content, error = file:read("*a")
    if (content == nil) then
        return false, error
    end
    file:close()
    return content
end

---Attempt create a directory with the given path.
---
---An error will occur if the directory can not be created.
---@param path string Path to the directory to create
---@return boolean
function create_directory(path)
    local success, error = os.execute("mkdir " .. path)
    if (not success) then
        return false
    end
    return true
end

---Attempt to remove a directory with the given path.
---
---An error will occur if the directory can not be removed.
---@param path string Path to the directory to remove
---@return boolean
function remove_directory(path)
    local success, error = os.execute("rmdir -r " .. path)
    if (not success) then
        return false
    end
    return true
end

---Verify if a directory exists given directory path
---@param path string
---@return boolean
function directory_exists(path)
    print("directory_exists", path)
    return os.execute("dir \"" .. path .. "\" > nul") == 0
end

---List the contents from a directory given directory path
---@param path string
---@return nil | integer | table
function list_directory(path)
    -- TODO This needs a way to separate folders from files
    if (path) then
        local command = "dir \"" .. path .. "\" /B"
        local pipe = io.popen(command, "r")
        if pipe then
            local output = pipe:read("*a")
            if (output) then
                local items = split(output, "\n")
                for index, item in pairs(items) do
                    if (item and item == "") then
                        items[index] = nil
                    end
                end
                return items
            end
        end
    end
    return nil
end

---Delete a file given file path
---@param path string
---@return boolean
function delete_file(path)
    return os.remove(path)
end

---Return if a file exists given file path.
---@param path string
---@return boolean
function file_exists(path)
    local file = io.open(path, "r")
    if (file) then
        file:close()
        return true
    end
    return false
end

---Return the memory address of a tag given tagId or tagClass and tagPath
---@param tagIdOrTagType string | number
---@param tagPath? string
---@return number?
function get_tag(tagIdOrTagType, tagPath)
    if (not tagPath) then
        return lookup_tag(tagIdOrTagType)
    else
        return lookup_tag(tagIdOrTagType, tagPath)
    end
end

---Execute a custom Halo script.
---
---A script can be either a standalone Halo command or a Lisp-formatted Halo scripting block.
---@param command string
function execute_script(command)
    return execute_command(command)
end

---Return the address of the object memory given object id
---@param objectId number
---@return number?
function get_object(objectId)
    if (objectId) then
        local object_memory = get_object_memory(objectId)
        if (object_memory ~= 0) then
            return object_memory
        end
    end
    return nil
end

---Despawn an object given objectId. An error will occur if the object does not exist.
---@param objectId number
function delete_object(objectId)
    destroy_object(objectId)
end

---Output text to the console, optional text colors in decimal format.<br>
---Avoid sending console messages if console_is_open() is true to avoid annoying the player.
---@param message string | number
---@param red? number
---@param green? number
---@param blue? number
function console_out(...)
    cprint(...)
end

---Output text to console as debug message.
---
---This function will only output text if the debug mode is enabled.
---@param message string
function console_debug(message)
    if DebugMode then
        console_out(message)
    end
end

---Return true if the player has the console open, always returns true on SAPP.
---@return boolean
function console_is_open()
    return true
end

---Get the value of a Halo scripting global.\
---An error will be triggered if the global is not found
---@param globalName string Name of the  global variable to get from hsc
---@return boolean | number
function get_global(globalName)
    if addressList.hscGlobals then
        local hsGlobals = addressList.hscGlobals
        -- local firstGlobal = read_dword(addressList.hscGlobals + 1)
        local firstGlobal = 0x00001ec
        local hsGlobalsTable = read_dword(hsGlobals)
        local hsTable = read_dword(hsGlobalsTable + 0x34)

        local scenarioTag = blam.getTagEntry(0).data
        local globalsCount = read_dword(scenarioTag + 0x4A8)
        local globalsAddress = read_dword(scenarioTag + 0x4A8 + 4)

        for i = 0, globalsCount - 1 do
            local global = globalsAddress + i * 92
            if read_string(global) == globalName then
                local globalType = read_word(global + 0x20)
                local location = hsTable + (i + firstGlobal) * 8
                if globalType == 5 then
                    return read_byte(location + 4) == 1
                elseif globalType == 6 then
                    return read_float(location + 4)
                elseif globalType == 7 then
                    return read_short(location + 4)
                elseif globalType == 8 then
                    return read_int(location + 4)
                else
                    return read_int(location + 4)
                end
            end
        end
    end
    error("Global not found: " .. globalName)
end

---Print message to player HUD.\
---Messages will be printed to console if SAPP uses this function
---@param message string
function hud_message(message)
    cprint(message)
end

---Set the callback for an event game from the game events available on Chimera
---@param event "command" | "frame" | "preframe" | "map load" | "precamera" | "rcon message" | "tick" | "pretick" | "unload"
---@param callback string Global function name to call when the event is triggered
function set_callback(event, callback)
    if event == "tick" then
        register_callback(cb["EVENT_TICK"], callback)
    elseif event == "pretick" then
        error("SAPP does not support pretick event")
    elseif event == "frame" then
        error("SAPP does not support frame event")
    elseif event == "preframe" then
        error("SAPP does not support preframe event")
    elseif event == "map load" then
        register_callback(cb["EVENT_GAME_START"], callback)
    elseif event == "precamera" then
        error("SAPP does not support precamera event")
    elseif event == "rcon message" then
        _G[callback .. "_rcon_message"] = function(playerIndex,
                                                   command,
                                                   environment,
                                                   password)
            return _G[callback](playerIndex, command, password)
        end
        register_callback(cb["EVENT_COMMAND"], callback .. "_rcon_message")
    elseif event == "command" then
        _G[callback .. "_command"] = function(playerIndex, command, environment)
            return _G[callback](playerIndex, command, environment)
        end
        register_callback(cb["EVENT_COMMAND"], callback .. "_command")
    elseif event == "unload" then
        register_callback(cb["EVENT_GAME_END"], callback)
    else
        error("Unknown event: " .. event)
    end
end

---Register a timer to be called every intervalMilliseconds.<br>
---The callback function will be called with the arguments passed after the callbackName.<br>
---
---**WARNING:** SAPP will not return a timerId, it will return nil instead so timers can not be stopped.
---@param intervalMilliseconds number
---@param globalFunctionCallbackName string
---@vararg any
---@return number?
function set_timer(intervalMilliseconds, globalFunctionCallbackName, ...)
    return timer(intervalMilliseconds, globalFunctionCallbackName, ...)
end

function stop_timer(timerId)
    error("SAPP does not support stopping timers")
end

-- register_callback is a SAPP only function, we are running in SAPP then
if register_callback then
    -- Provide global server type variable on SAPP
    server_type = "sapp"
    print("Compatibility with Chimera Lua API has been loaded!")
else
    console_is_open = backupFunctions.console_is_open
    console_out = backupFunctions.console_out
    execute_script = backupFunctions.execute_script
    get_global = backupFunctions.get_global
    -- set_global = -- backupFunctions.set_global
    get_tag = backupFunctions.get_tag
    set_callback = backupFunctions.set_callback
    set_timer = backupFunctions.set_timer
    stop_timer = backupFunctions.stop_timer
    spawn_object = backupFunctions.spawn_object
    delete_object = backupFunctions.delete_object
    get_object = backupFunctions.get_object
    get_dynamic_player = backupFunctions.get_dynamic_player
    hud_message = backupFunctions.hud_message
    create_directory = backupFunctions.create_directory
    remove_directory = backupFunctions.remove_directory
    directory_exists = backupFunctions.directory_exists
    list_directory = backupFunctions.list_directory
    write_file = backupFunctions.write_file
    read_file = backupFunctions.read_file
    delete_file = backupFunctions.delete_file
    file_exists = backupFunctions.file_exists
end

------------------------------------------------------------------------------
-- Generic functions
------------------------------------------------------------------------------

--- Verify if the given variable is a number
---@param var any
---@return boolean
local function isNumber(var)
    return (type(var) == "number")
end

--- Verify if the given variable is a string
---@param var any
---@return boolean
local function isString(var)
    return (type(var) == "string")
end

--- Verify if the given variable is a boolean
---@param var any
---@return boolean
local function isBoolean(var)
    return (type(var) == "boolean")
end

--- Verify if the given variable is a table
---@param var any
---@return boolean
local function isTable(var)
    return (type(var) == "table")
end

--- Remove spaces and tabs from the beginning and the end of a string
---@param str string
---@return string
local function trim(str)
    return str:match("^%s*(.*)"):match("(.-)%s*$")
end

--- Verify if the value is valid
---@param var any
---@return boolean
local function isValid(var)
    return (var and var ~= "" and var ~= 0)
end

------------------------------------------------------------------------------
-- Utilities
------------------------------------------------------------------------------

--- Convert a tag group integer into a tag group string.
---@param tagClassInt number
---@return string
local function integerToTagGroup(tagClassInt)
    local tagClassHex = tohex(tagClassInt)
    local tagClass
    if isNull(tagClassInt) then
        return nil
    end
    if tagClassHex then
        local byte = ""
        tagClass = ""
        for char in string.gmatch(tagClassHex, ".") do
            byte = byte .. char
            if #byte % 2 == 0 then
                tagClass = tagClass .. string.char(tonumber(byte, 16))
                byte = ""
            end
        end
    end
    return tagClass
end

blam.integerToTagGroup = integerToTagGroup

--- Return a list of object indexes that are currently spawned, indexed by their object id.
---@return number[]
function blam.getObjects()
    local objects = {}
    for objectIndex = 0, 2047 do
        local object, objectId = blam.getObject(objectIndex)
        if object and objectId then
            objects[objectId] = objectIndex
            -- objects[objectIndex] = objectId
        end
    end
    return objects
end

-- Local reference to the original console_out function
local original_console_out = console_out

--- Print a console message. It also supports multi-line messages!
---@param message string
local function consoleOutput(message, ...)
    -- Put the extra arguments into a table
    local args = {...}

    if (message == nil or #args > 5) then
        consoleOutput(debug.traceback("Wrong number of arguments on console output function", 2),
                      consoleColors.error)
    end

    -- Output color
    local colorARGB = {1, 1, 1, 1}

    -- Get the output color from arguments table
    if (isTable(args[1])) then
        colorARGB = args[1]
    elseif (#args == 3 or #args == 4) then
        colorARGB = args
    end

    -- Set alpha channel if not set
    if (#colorARGB == 3) then
        table.insert(colorARGB, 1, 1)
    end

    if message then
        if (isString(message)) then
            -- Explode the string!!
            for line in message:gmatch("([^\n]+)") do
                -- Trim the line
                local trimmedLine = trim(line)

                -- Print the line
                original_console_out(trimmedLine, table.unpack(colorARGB))
            end
        else
            original_console_out(message, table.unpack(colorARGB))
        end
    end
end

--- Return a boolean from `v` if it is a boolean like value.
---@param v string | boolean | number
---@return boolean
local function bool(v)
    assert(v ~= nil, "bool: v must not be nil")
    return v == true or v == "true" or v == 1 or v == "1"
end

--- Return a bit (number as 0 or 1) from `v` if it is a boolean like value.
---@param v string | boolean | number
---@return integer
---@nodiscard
local function bit(v)
    assert(v ~= nil, "bit: v must not be nil")
    return bool(v) and 1 or 0
end

------------------------------------------------------------------------------
-- Data manipulation and binding
------------------------------------------------------------------------------

--- Return the string of a unicode string given address
---@param address number
---@param rawRead? boolean
---@return string
function blam.readUnicodeString(address, rawRead)
    local stringAddress
    if rawRead then
        stringAddress = address
    else
        stringAddress = read_dword(address)
    end
    local output = ""
    local i = 0
    -- TODO Refactor this to support reading ASCII and UTF16? strings
    while true do
        local char = read_string(stringAddress + i * 0x2)
        -- local _, char = pcall(string.char, read_byte(stringAddress + (i - 1) * 0x2))
        if not char or char == "" then
            break
        end
        output = output .. char
        i = i + 1
    end
    return output
end

--- Writes a unicode string in a given address
---@param address number
---@param newString string
---@param rawWrite? boolean
---@param noNullTerminator? boolean
function blam.writeUnicodeString(address, newString, rawWrite, noNullTerminator)
    local stringAddress
    if rawWrite then
        stringAddress = address
    else
        stringAddress = read_dword(address)
    end
    -- Allow cancelling writing when the new string is a boolean false value
    if newString == false then
        return
    end
    local newString = tostring(newString)
    -- TODO Refactor this to support writing ASCII and UTF16? strings
    for i = 1, #newString do
        local char = newString:sub(i, i)
        local byte = string.byte(char) or string.byte("?")
        local currentCharAddress = stringAddress + (i - 1) * 0x2
        write_dword(currentCharAddress, byte)
        if i == #newString and not noNullTerminator then
            write_dword(currentCharAddress + 0x2, 0x0)
        end
    end
    if #newString == 0 then
        write_dword(stringAddress, 0)
    end
end

local cTypes = {
    bit = {
        read = function(addr, offset)
            return bool(read_bit(addr, offset))
        end,
        write = function(addr, offset, value)
            write_bit(addr, offset, bit(value))
        end
    },
    bool = {
        read = function(addr)
            return bool(read_byte(addr))
        end,
        write = function(addr, value)
            write_byte(addr, bit(value))
        end
    },
    char = {read = read_byte, write = write_byte},
    byte = {
        read = function(addr)
            read_byte(addr)
        end,
        write = function(addr, value)
            write_byte(addr, value)
        end
    },
    short = {read = read_short, write = write_short},
    word = {read = read_word, write = write_word},
    long = {read = read_long, write = write_long},
    int = {read = read_int, write = write_int},
    dword = {read = read_dword, write = write_dword},
    float = {read = read_float, write = write_float},
    double = {read = read_double, write = write_double},
    string = {read = read_string, write = write_string},
    ptr = {read = read_dword, write = write_dword}
}

------------------------------------------------------------------------------
-- Struct functions
------------------------------------------------------------------------------

--- Create a table binded to a structure properties
---@param struct table
---@param address integer
---@return table
local function createBindStruct(address, struct)
    -- print("Creating bind struct for address: " .. string.format("0x%x", address))
    local tableStruct = {_address = address, _struct = struct, _addr = string.format("0x%x", address)}
    setmetatable(tableStruct, {
        __index = function(t, key)
            if #struct == 0 then
                struct = table.map(table.keys(struct), function(k)
                    return {name = k, type = struct[k].type, offset = struct[k].offset, is = struct[k].is, fields = struct[k].fields}
                end)
            end
            local fieldMeta = table.find(struct, function(f)
                return f.name == key
            end)
            if not fieldMeta then
                error("Field '" .. key .. "' not found in struct")
                return
            end
            local isPointer = fieldMeta.is == "ptr"
            local address = isPointer and cTypes.ptr.read(address + fieldMeta.offset) or
                                (address + fieldMeta.offset)

            --print("Accessing field: " .. fieldMeta.name .. ", Type: " .. fieldMeta.type .. ", Address: " .. string.format("0x%x", address))
            if cTypes[fieldMeta.type] and cTypes[fieldMeta.type].read then
                return cTypes[fieldMeta.type].read(address)
            elseif fieldMeta.is == "struct" then
                return createBindStruct(address, fieldMeta.fields)
            elseif fieldMeta.is == "array" then
                -- TODO
            else
                --error("Unsupported type: " .. fieldMeta.type)
                print("Unsupported type: " .. fieldMeta.type .. " for field: " .. fieldMeta.name)
            end
        end,
        __newindex = function(t, key, value)
            local field = table.find(struct, function(f)
                return f.name == key
            end)
            if not field then
                return
            end
            local isPointer = field.is == "ptr"
            local address = isPointer and cTypes.ptr.read(address + field.offset) or
                                (address + field.offset)
            if cTypes[field.type] and cTypes[field.type].write then
                cTypes[field.type].write(address, value)
            elseif field.is == "struct" then
                -- If it's a struct, we can set fields directly as it will trigger the __index metamethod
                if type(value) == "table" then
                    for k, v in pairs(value) do
                        t[k] = v
                    end
                else
                    error("Expected a table for struct assignment")
                end
            else
                error("Unsupported type: " .. field.type)
            end
        end
    })

    return tableStruct
end

--- Return a dump version of a binded structure table
---@param t table
---@return table
local function dumpTable(t)
    local dump = {}
    for k, v in pairs(t._struct) do
        dump[k] = t[k]
    end
    --dump._address = t._address
    --dump._addr = t._addr
    --dump._struct = t._struct
    return dump
end

--- Return a extended parent structure with another given structure
---@param parent table
---@param structure table
---@return table
local function extendStructure(parent, structure)
    local extendedStructure = {}
    for k, v in pairs(parent) do
        extendedStructure[k] = v
    end
    for k, v in pairs(structure) do
        extendedStructure[k] = v
    end
    return extendedStructure
end

------------------------------------------------------------------------------
-- Object structures
------------------------------------------------------------------------------

---@class dataTable
---@field name string
---@field maxElements number
---@field elementSize number
---@field capacity number
---@field size number
---@field nextElementId number
---@field firstElementAddress number

local dataTableStructure = {
    name = {type = "string", offset = 0},
    maxElements = {type = "word", offset = 0x20},
    elementSize = {type = "word", offset = 0x22},
    -- padding1 = {size = 0x0A, offset = 0x24},
    capacity = {type = "word", offset = 0x2E},
    size = {type = "word", offset = 0x30},
    nextElementId = {type = "word", offset = 0x32},
    firstElementAddress = {type = "dword", offset = 0x34}
}


-- Tag data header structure
local tagDataHeaderStructure = {
    array = {type = "dword", offset = 0x0},
    scenario = {type = "dword", offset = 0x4},
    count = {type = "word", offset = 0xC}
}

---@class tagEntry
---@field primaryGroup string Primary group of the tag
---@field secondaryGroup string Secondary group of the tag
---@field tertiaryGroup string Tertiary group of the tag
---@field handle number Tag handle, used for tag references
---@field path string Path of the tag
---@field data number Address of the tag data
---@field indexed boolean Is tag indexed on an external map file

-- Tag structure
local tagEntryStructure = {
    primaryGroup = {type = "dword", offset = 0x0},
    secondaryGroup = {type = "dword", offset = 0x4},
    tertiaryGroup = {type = "dword", offset = 0x8},
    index = {type = "word", offset = 0xC}, -- Deprecated, use handle instead
    id = {type = "dword", offset = 0xC}, -- Deprecated, use handle instead
    handle = {type = "dword", offset = 0xC},
    path = {type = "string", offset = 0x10, is = "ptr"},
    data = {type = "dword", offset = 0x14},
    indexed = {type = "dword", offset = 0x18}
}

---@class cinematicGlobals
---@field isInProgress boolean
---@field isShowingLetterbox boolean

local cinematicGlobalsStructure = {
    isInProgress = {type = "bit", offset = 0x9, bitLevel = 0},
    isShowingLetterbox = {type = "bit", offset = 0x8, bitLevel = 0}
}

------------------------------------------------------------------------------
-- LuaBlam globals
------------------------------------------------------------------------------

-- Provide with public blam! data tables
blam.addressList = addressList
blam.tag.groups = tagGroups
blam.objectClasses = objectClasses
blam.joystickInputs = joystickInputs
blam.dPadValues = dPadValues
blam.cameraTypes = cameraTypes
blam.consoleColors = consoleColors
blam.netgameFlagClasses = netgameFlagClasses
blam.gameTypeClasses = gameTypeClasses
blam.multiplayerTeamClasses = multiplayerTeamClasses
blam.unitTeamClasses = unitTeamClasses
blam.objectNetworkRoleClasses = objectNetworkRoleClasses

---@class tagDataHeader
---@field array any
---@field scenario string
---@field count number

---@type tagDataHeader
blam.tagDataHeader = createBindStruct(addressList.tagDataHeader, tagDataHeaderStructure)

------------------------------------------------------------------------------
-- LuaBlam API
------------------------------------------------------------------------------

-- Add utilities to library
blam.dumpTable = dumpTable
blam.consoleOutput = consoleOutput
blam.null = null

---Get the current game camera type
---@return number?
function blam.getCameraType()
    local camera = read_word(addressList.cameraType)
    if camera then
        if camera == 22192 then
            return cameraTypes.scripted
        elseif camera == 30400 then
            return cameraTypes.firstPerson
        elseif camera == 30704 then
            return cameraTypes.devcam
            -- FIXME Validate this value, it seems to be wrong!
        elseif camera == 21952 then
            return cameraTypes.thirdPerson
        elseif camera == 23776 then
            return cameraTypes.deadCamera
        end
    end
    return nil
end

--- Get input from joystick assigned in the game
---@param joystickOffset number Offset input from the joystick data, use blam.joystickInputs
---@return boolean | number Value of the joystick input
function blam.getJoystickInput(joystickOffset)
    -- Based on aLTis controller method
    -- TODO Check if it is better to return an entire table with all input values 
    joystickOffset = joystickOffset or 0
    -- Nothing is pressed by default
    ---@type boolean | number
    local inputValue = 0
    -- Look for every input from every joystick available
    for controllerId = 0, 3 do
        local inputAddress = addressList.joystickInput + controllerId * 0xA0
        if (joystickOffset >= 30 and joystickOffset <= 38) then
            -- Sticks
            inputValue = inputValue + read_long(inputAddress + joystickOffset)
        elseif (joystickOffset > 96) then
            -- D-pad related
            local tempValue = read_word(inputAddress + 96)
            if (tempValue == joystickOffset - 100) then
                inputValue = true
            else
                inputValue = false
            end
        else
            inputValue = inputValue + read_byte(inputAddress + joystickOffset)
        end
    end
    return inputValue
end

--- Create a tag object from a given address, this object can't write data to game memory
---@param address integer
---@return tag?
local function createTag(address)
    if address and address ~= 0 then
        -- Generate a new tag object from class
        local tag = createBindStruct(address, tagEntryStructure)
        -- Convert binding into a raw table
        tag = dumpTable(tag)

        tag.primaryGroup = integerToTagGroup(tag.primaryGroup)
        tag.secondaryGroup = integerToTagGroup(tag.secondaryGroup)
        tag.tertiaryGroup = integerToTagGroup(tag.tertiaryGroup)

        local tagStructureModuleName
        for name, tagGroup in pairs(tagGroups) do
            if tag.primaryGroup == tagGroup then
                tagStructureModuleName = name
                break
            end
        end

        if not tagStructureModuleName then
            error("Tag group not found for tag: " .. tag.primaryGroup)
        end

        --print("tag.primaryGroup", tag.primaryGroup)
        --print("tagStructureModuleName", tagStructureModuleName)

        local _, struct = pcall(require, "structures." .. tagStructureModuleName)
        if struct then
            tag.data = createBindStruct(tag.data, struct)
        end

        return tag
    end
    return nil
end

--- Return a tag object given tagPath and tagClass or just tagId
---@param tagIdOrTagPath string | number
---@param tagClass? string
---@return tag?
function blam.getTagEntry(tagIdOrTagPath, tagClass, ...)
    local tagId
    local tagPath

    -- Get arguments from table
    if isNumber(tagIdOrTagPath) then
        tagId = tagIdOrTagPath
    elseif isString(tagIdOrTagPath) then
        tagPath = tagIdOrTagPath
    elseif not tagIdOrTagPath then
        return nil
    end

    if (...) then
        consoleOutput(debug.traceback("Wrong number of arguments on get tag function", 2),
                      consoleColors.error)
    end

    local tagAddress

    -- Get tag address
    if tagId then
        if tagId < 0xFFFF then
            -- Calculate tag id
            tagId = read_dword(blam.tagDataHeader.array + (tagId * 0x20 + 0xC))
        end
        tagAddress = get_tag(tagId)
    elseif tagClass and tagPath then
        tagAddress = get_tag(tagClass, tagPath --[[@as string]] )
    end

    if tagAddress then
        return createTag(tagAddress)
    end
end

--- Create a First person object from a given address, game known address by default
---@param address? number
---@return firstPerson
function blam.firstPerson(address)
    return createBindStruct(address or addressList.firstPerson, firstPersonStructure)
end

--- Return a blam object given object index or id.
--- Also returns objectId when given an object index.
---@param idOrIndex number
---@return blamObject?, number?
function blam.getObject(idOrIndex)
    local objectId
    local objectAddress

    -- Get object address
    if (idOrIndex) then
        -- Get object ID
        if (idOrIndex < 0xFFFF) then
            local index = idOrIndex

            -- Get objects table
            local table = createBindStruct(addressList.objectTable, dataTableStructure)
            if (index > table.capacity) then
                return nil
            end

            -- Calculate object ID (this may be invalid, be careful)
            objectId =
                (read_word(table.firstElementAddress + index * table.elementSize) * 0x10000) + index
        else
            objectId = idOrIndex
        end

        objectAddress = get_object(objectId)

        if objectAddress then
            return blam.object(objectAddress), objectId
        end
    end
    return nil
end

--- Return an element from the device machines table
---@param index number
---@return number?
function blam.getDeviceGroup(index)
    -- Get object address
    if index then
        -- Get objects table
        local table = createBindStruct(read_dword(addressList.deviceGroupsTable),
                                       deviceGroupsTableStructure)
        -- Calculate object ID (this may be invalid, be careful)
        local itemOffset = table.elementSize * index
        local item = read_float(table.firstElementAddress + itemOffset + 0x4)
        return item
    end
    return nil
end

local syncedObjectsTable = {
    maximumObjectsCount = {type = "dword", offset = 0x0},
    initialized = {type = "byte", offset = 0xC},
    objectsCount = {type = "dword", offset = 0x18},
    firstElementAddress = {type = "dword", offset = 0x28}
}

local function getSyncedObjectsTable()
    local tableAddress
    if blam.isGameSAPP() then
        tableAddress = addressList.syncedNetworkObjects
    else
        tableAddress = read_dword(addressList.syncedNetworkObjects)
        if tableAddress == 0 then
            console_out("Synced objects table is not accesible yet.")
            return nil
        end
    end

    return createBindStruct(tableAddress, syncedObjectsTable)
end

--- Return the maximum allowed network objects count
---@return number
function blam.getMaximumNetworkObjects()
    local syncedObjectsTable = getSyncedObjectsTable()
    if not syncedObjectsTable then
        return engineConstants.defaultNetworkObjectsCount
    end

    -- For some reason fist element entry is always used, so we need to substract 1
    return syncedObjectsTable.maximumObjectsCount - 1
end

--- Return an element from the synced objects table
---@param index number
---@return number?
function blam.getObjectIdBySyncedIndex(index)
    if index then
        local syncedObjectsTable = getSyncedObjectsTable()
        if not syncedObjectsTable then
            return nil
        end

        if syncedObjectsTable.objectsCount == 0 then
            return nil
        end
        if not syncedObjectsTable.initialized == 1 then
            return nil
        end
        -- For some reason fist element entry is always used, so we need to substract 1
        if index >= syncedObjectsTable.maximumObjectsCount - 1 then
            return nil
        end

        local entryOffset = 4 * index
        -- Ignore first entry, it's always used so add 4 bytes offset
        local entryAddress = syncedObjectsTable.firstElementAddress + entryOffset + 0x4
        local objectId = read_dword(entryAddress)
        if blam.isNull(objectId) then
            return nil
        end
        return objectId
    end
    return nil
end

---@class blamRequest
---@field requestString string
---@field timeout number
---@field callback function<boolean, string>
---@field sentAt number

local rconEvents = {}
local maxRconDataLength = 60

blam.rcon = {}

---Define a request event callback
---@param eventName string
---@param callback fun(message?: string, playerIndex?: number): string?
function blam.rcon.event(eventName, callback)
    rconEvents[eventName:lower()] = callback
end

---Dispatch an rcon event to a client or server trough rcon.
---
--- As a client, you can only send messages to the server.
---
--- As a server, you can send messages to a specific client or all clients.
---@param eventName string Path or name of the resource we want to get
---@param message? string Message to send to the server
---@param playerIndex? number Player index to send the message to
---@overload fun(eventName: string, playerIndex: number)
---@return {callback: fun(callback: fun(response: string, playerIndex?: number))}
function blam.rcon.dispatch(eventName, message, playerIndex)
    -- if server_type ~= "dedicated" then
    --    console_out("Warning, requests only work while connected to a dedicated server.")
    -- end
    assert(eventName ~= nil, "Event must not be empty")
    assert(type(eventName) == "string", "Event must be a string")
    local message = message
    local playerIndex = playerIndex
    if message and type(message) == "number" then
        playerIndex = message
        message = nil
    end
    if eventName then
        if blam.isGameSAPP() then
            if playerIndex then
                rprint(playerIndex, ("?%s?%s"):format(eventName, message))
            else
                for i = 1, 16 do
                    rprint(i, ("?%s?%s"):format(eventName, message))
                end
            end
        else
            local request = ("?%s?%s"):format(eventName, message)
            assert(#request <= maxRconDataLength, "Rcon request is too long")
            if blam.isGameDedicated() then
                execute_script("rcon blam " .. request)
            else
                blam.rcon.handle(request)
            end
        end
        return {
            callback = function()
                blam.rcon.event(eventName .. "+", callback)
            end
        }
    end
    error("No event name provided")
end

---Evaluate rcon event and handle it as a request
---@param data string
---@param password? string
---@param playerIndex? number
---@return boolean | nil
function blam.rcon.handle(data, password, playerIndex)
    if data:sub(1, 1) == "?" then
        if blam.isGameSAPP() then
            if password ~= "blam" then
                return nil
            end
        end
        local data = split(data, "?")
        local eventName = data[2]
        local message = data[3]
        local event = rconEvents[eventName:lower()]
        if event then
            local response = event(message, playerIndex)
            if response then
                if blam.isGameSAPP() then
                    rprint(playerIndex, response)
                else
                    execute_script(("rcon blam ?%s?%s"):format(eventName .. "+", response))
                end
            end
            return false
        else
            error("No rcon event handler for " .. eventName)
        end
    end
    -- Pass request to the server
    return nil
end

local passwordAddress
local failMessageAddress

---Patch rcon server function to avoid failed rcon messages
function blam.rcon.patch()
    passwordAddress = read_dword(sig_scan("7740BA??????008D9B000000008A01") + 0x3)
    failMessageAddress = read_dword(sig_scan("B8????????E8??000000A1????????55") + 0x1)
    if passwordAddress and failMessageAddress then
        -- Remove "rcon command failure" message
        safe_write(true)
        write_byte(failMessageAddress, 0x0)
        safe_write(false)
        -- Read current rcon in the server
        local serverRcon = read_string(passwordAddress)
        if serverRcon then
            console_out("Server rcon password is: \"" .. serverRcon .. "\"")
        else
            console_out("Error, at getting server rcon, please set and enable rcon on the server.")
        end
    else
        console_out("Error, at obtaining rcon patches, please check SAPP version.")
    end
end

---Unpatch rcon server function to restore failed rcon messages
function blam.rcon.unpatch()
    if failMessageAddress then
        -- Restore "rcon command failure" message
        safe_write(true)
        write_byte(failMessageAddress, 0x72)
        safe_write(false)
    end
end

--- Find a tag entry by keyword and tag group
--- This function will return the first tag that matches the keyword and tag group.
--- If no tag is found, it will return nil.
---@param keyword string
---@param tagGroup tagGroup
---@return tag? tag
function blam.tag.findTag(keyword, tagGroup)
    for tagIndex = 0, blam.tagDataHeader.count - 1 do
        local tag = blam.getTagEntry(tagIndex)
        if tag and tag.path:find(keyword, 1, true) and tag.primaryGroup == tagGroup then
            return tag
        end
    end
    return nil
end

--- Find a list of tag entries by keyword and tag group
--- This function will return a list of tags that match the keyword and tag group.
--- If no tags are found, it will return an empty table.
---@param keyword string
---@param tagGroup tagGroup
---@return tagEntry[] tag
function blam.tag.findTags(keyword, tagGroup)
    local tagsList = {}
    for tagIndex = 0, blam.tagDataHeader.count - 1 do
        local tag = blam.getTagEntry(tagIndex)
        if tag and tag.path:find(keyword, 1, true) and tag.primaryGroup == tagGroup then
            tagsList[#tagsList + 1] = tag
        end
    end
    return tagsList
end

--- Return the index of a resource handle
---@param handle integer
function blam.getIndexFromHandle(handle)
    if handle then
        return fmod(handle, 0x10000)
    end
    return nil
end

---@class vector2D
---@field x number
---@field y number

---@class vector3D
---@field x number
---@field y number
---@field z number

---@class vector4D
---@field x number
---@field y number
---@field z number
---@field w number

---Returns game rotation vectors from euler angles, return optional rotation matrix, based on
---[source.](https://www.mecademic.com/en/how-is-orientation-in-space-represented-with-euler-angles)
--- @param yaw number
--- @param pitch number
--- @param roll number
--- @return vector3D, vector3D
local function eulerAnglesToVectors(yaw, pitch, roll)
    local yaw = rad(yaw)
    local pitch = rad(-pitch) -- Negative pitch due to Sapien handling anticlockwise pitch
    local roll = rad(roll)
    local matrix = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}

    -- Roll, Pitch, Yaw = a, b, y
    local cosA = cos(roll)
    local sinA = sin(roll)
    local cosB = cos(pitch)
    local sinB = sin(pitch)
    local cosY = cos(yaw)
    local sinY = sin(yaw)

    matrix[1][1] = cosB * cosY
    matrix[1][2] = -cosB * sinY
    matrix[1][3] = sinB
    matrix[2][1] = cosA * sinY + sinA * sinB * cosY
    matrix[2][2] = cosA * cosY - sinA * sinB * sinY
    matrix[2][3] = -sinA * cosB
    matrix[3][1] = sinA * sinY - cosA * sinB * cosY
    matrix[3][2] = sinA * cosY + cosA * sinB * sinY
    matrix[3][3] = cosA * cosB

    local v1 = {x = matrix[1][1], y = matrix[2][1], z = matrix[3][1]}
    local v2 = {x = matrix[1][3], y = matrix[2][3], z = matrix[3][3]}

    return v1, v2
end

--- Get euler angles rotation from game rotation vectors
--- @param v1 vector3D Vector with first column values from rotation matrix
--- @param v2 vector3D Vector with third column values from rotation matrix
--- @return number yaw, number pitch, number roll
local function vectorsToEulerAngles(v1, v2)
    local v3 = {
        x = v1.y * v2.z - v1.z * v2.y,
        y = v1.z * v2.x - v1.x * v2.z,
        z = v1.x * v2.y - v1.y * v2.x
    }

    local matrix = {{v1.x, v3.x, v2.x}, {v1.y, v3.y, v2.y}, {v1.z, v3.z, v2.z}}

    -- Extract individual matrix elements
    local m11, m12, m13 = matrix[1][1], matrix[1][2], matrix[1][3]
    local m21, m22, m23 = matrix[2][1], matrix[2][2], matrix[2][3]
    local m31, m32, m33 = matrix[3][1], matrix[3][2], matrix[3][3]

    -- Calculate yaw (heading) angle
    local yaw = atan2(m12, m11)

    -- Calculate pitch (attitude) angle
    local pitch = atan2(-m13, sqrt(m23 ^ 2 + m33 ^ 2))

    -- Calculate roll (bank) angle
    local roll = -atan2(m23, m33)

    -- Convert angles from radians to degrees
    yaw = deg(yaw)
    pitch = deg(pitch)
    roll = deg(roll)

    -- Adjust angles to the range [0, 359]
    yaw = fmod(yaw + 360, 360)
    pitch = fmod(pitch + 360, 360)
    roll = fmod(roll + 360, 360)

    return yaw, pitch, roll
end

--- Get rotation angles from game object
---
--- Assuming clockwise rotation and absolute angles from 0 to 360
---@param object blamObject
---@return number yaw, number pitch, number roll
function blam.getObjectRotation(object)
    local v1 = {x = object.vX, y = object.vY, z = object.vZ}
    local v2 = {x = object.v2X, y = object.v2Y, z = object.v2Z}
    return vectorsToEulerAngles(v1, v2)
end

--- Get rotation angles from game vectors
---
--- Assuming clockwise rotation and absolute angles from 0 to 360
---@param v1 vector3D
---@param v2 vector3D
---@return number yaw, number pitch, number roll
function blam.getVectorRotation(v1, v2)
    return vectorsToEulerAngles(v1, v2)
end

--- Rotate object into desired angles
---
--- Assuming clockwise rotation and absolute angles from 0 to 360
---@param object blamObject
---@param yaw number
---@param pitch number
---@param roll number
function blam.rotateObject(object, yaw, pitch, roll)
    local v1, v2 = eulerAnglesToVectors(yaw, pitch, roll)
    object.vX = v1.x
    object.vY = v1.y
    object.vZ = v1.z
    object.v2X = v2.x
    object.v2Y = v2.y
    object.v2Z = v2.z
end

--- Get screen resolution
---@return {width: number, height: number, aspectRatio: number}
function blam.getScreenData()
    local height = read_word(addressList.screenResolution)
    local width = read_word(addressList.screenResolution + 0x2)
    return {width = width, height = height, aspectRatio = width / height}
end

--- Get the current game state
---@return {isLayerOpened: boolean, isGamePaused: boolean}
function blam.getGameState()
    return {
        isLayerOpened = read_byte(addressList.gameOnMenus) == 0,
        isGamePaused = read_byte(addressList.gamePaused) == 0
    }
end

--- Get object absolute coordinates
---Returns the absolute coordinates of an object, considering parent object coordinates if any.
---@param object blamObject
---@return vector3D
function blam.getAbsoluteObjectCoordinates(object)
    local coordinates = {x = object.x, y = object.y, z = object.z}
    if not isNull(object.parentObjectId) then
        local parentObject = blam.object(get_object(object.parentObjectId))
        if parentObject then
            coordinates.x = coordinates.x + parentObject.x
            coordinates.y = coordinates.y + parentObject.y
            coordinates.z = coordinates.z + parentObject.z
        end
    end
    return coordinates
end

--- Returns binded table to game cinematic globals
---@return cinematicGlobals
function blam.cinematicGlobals()
    return createBindStruct(read_dword(addressList.cinematicGlobals), cinematicGlobalsStructure)
end

--- Returns current game difficulty index
---@return number
function blam.getGameDifficultyIndex()
    local hscGlobals = read_dword(addressList.hscGlobalsPointer)
    return read_byte(hscGlobals + 0xe)
end

return blam
