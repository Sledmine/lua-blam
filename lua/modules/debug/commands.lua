local inspect = require "inspect"
local engine = Engine
local balltze = Balltze
local consolePrint = engine.core.consolePrint
local findTags = engine.tag.findTags
local luna = require "luna"
--_G = table.merge(_G, balltze.chimera)
--local _, blam = pcall(require, "blam")
local blam = require "blam"

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

---@type table<string, EngineColorARGB>
local consoleColors = {
    error = { 
        alpha = 1,
        red = 1,
        green = 0.2,
        blue = 0.2
    },
    success = {
        alpha = 1,
        red = 0.235,
        green = 0.82,
        blue = 0
    },
    warning = {
        alpha = 1,
        red = 0.94,
        green = 0.75,
        blue = 0.098
    },
    unknown = {
        alpha = 1,
        red = 0.66,
        green = 0.66,
        blue = 0.66
    }
}

--- Get if given value equals a null value in game engine terms
---@param value any
---@return boolean
local function isNull(value)
    if value == 0xFF or value == 0xFFFF or value == null or value == nil then
        return true
    end
    return false
end

local commands = {}

local lastSpawnedObjectHandle = nil

local function console_command_info(command)
    consolePrint(command .. ": " .. commands[command].description)
end

local function nulled(value)
    if isNull(value) then
        return "NULL"
    end
    return value
end

local function getTagName(tagId)
    local tag = blam.getTag(tagId)
    if tag then
        return tag.path:match("\\([^\\]+)$")
    end
end

local function getTagFromObjectHandle(objectHandle)
    if isNull(objectHandle) then
        return "NULL"
    end
    local object = blam.object(get_object(objectHandle))
    if object then
        return getTagName(object.tagId)
    end
end

--- Spawn an object in the map
---@param tagClass string
---@param tagName string
local function spawn(tagClass, tagName, ...)
    local tagName = tagName or ""
    local tagClass = engine.tag.classes[tagClass]
    tagName = table.concat({tagName, ...}, " ")
    tagName = tagName:trim()
    if not (tagClass and tagName) then
        console_command_info("debug_spawn")
        return false
    end
    local tag = findTags(tagName, tagClass)[1]
    if tag then
        local biped
        local player
        if engine.netgame.getServerType() == "dedicated" then
            player = engine.gameState.getPlayer(PlayerIndexExecutingCommand)
        else
            player = engine.gameState.getPlayer()
        end
        if not player then
            consolePrint("Error, player biped cannot be found.")
            return false
        end
        if player then
            biped = engine.gameState.getObject(player.objectHandle, engine.tag.objectType.biped)
            assert(biped, "Error, player biped cannot be found.")
            -- TODO Check if we can add __pairs metamethod to the object
            --for key, value in pairs(biped) do
            --    consolePrint(key .. ": " .. tostring(value))
            --end
        end
        local position = {
            -- TODO Check alternatives for cameraX, cameraY, cameraZ
            --x = biped.aimingVector.i,
            x = biped.position.x,
            y = biped.position.y,
            z = biped.position.z + 2
        }
        local object = engine.gameState.createObject(tag.handle, nil, position)
        if object then
            -- TODO Check alternatives for isOutSideMap
            -- if object and not object.isOutSideMap then
            if object then
                consolePrint("Object successfully spawned!")
                lastSpawnedObjectHandle = object
                return false
            else
                engine.gameState.deleteObject(object.handle)
                consolePrint(
                    "Error, specified object can not be spawned inside the map.")
                return false
            end
        end
    end
    consolePrint("Error, specified object tag cannot be found.")
end

--- List all tags of the specified class, optionally filtered by name
---@param tagClass EngineTagClass
---@param tagName string
local function list(tagClass, tagName)
    local tagClass = engine.tag.classes[tagClass]
    local tagName = tagName or ""
    if tagClass then
        local tags = findTags(tagName, tagClass)
        if tags then
            for _, tag in pairs(tags) do
                consolePrint(("[Index: %s, Handle: %s] - %s"):format(tag.handle.index, tag.handle.value, tag.path))
            end
            return false
        end
    else
        console_command_info("debug_list")
        return false
    end
    consolePrint("Error, no tags were found.")
end

local function enterVehicle(objectIndex, vehicleIndex, seat)
    local objectIndex = tonumber(objectIndex)
    local vehicleIndex = tonumber(vehicleIndex)
    if not objectIndex then
        objectIndex = lastSpawnedObjectHandle
    end
    if not vehicleIndex then
        vehicleIndex = lastSpawnedObjectHandle
    end
    assert(objectIndex, "Error, object index must be a number.")
    assert(vehicleIndex, "Error, vehicle index must be a number.")
    local _, objectId = blam.getObject(objectIndex)
    assert(objectId, "Error, object cannot be found.")
    local _, vehicleId = blam.getObject(vehicleIndex)
    assert(vehicleId, "Error, vehicle cannot be found.")
    --require"mods.balltze".unit_enter_vehicle(objectId, vehicleId, 0)
    engine.gameState.unitEnterVehicle(objectId, vehicleId, tonumber(seat) or seat)
    return false
end

local function exitVehicle(objectIndex)
    local objectIndex = tonumber(objectIndex)
    if not objectIndex then
        objectIndex = lastSpawnedObjectHandle
    end
    assert(objectIndex, "Error, object index must be a number.")
    local object, objectId = blam.getObject(objectIndex)
    engine.gameState.unitExitVehicle(objectId)
    return false
end

local function playerAnimation(animationIndex)
    local animationIndex = tonumber(animationIndex)
    assert(animationIndex, "Error, animation index must be a number.")
    local player = engine.gameState.getPlayer()
    if not player then
        consolePrint("Error, player biped cannot be found.")
        return false
    end
    local biped = engine.gameState.getObject(player.objectHandle, engine.tag.objectType.biped)
    if biped then
        biped.animationIndex = animationIndex
        biped.animationFrame = 0
    end
end

local function playerSpeed(speed)
    local newSpeed = tonumber(speed)
    assert(newSpeed, "Error, speed must be a number.")
    local player = blam.player(get_player())
    if player then
        player.speed = newSpeed
    end
end

local function objectProperty(objectIndex, key, value)
    local objectIndex = tonumber(objectIndex)
    if not objectIndex then
        objectIndex = lastSpawnedObjectHandle
    end
    if value then
        if value == "LAST_OBJECT" then
            value = lastSpawnedObjectHandle
        elseif value == "NULL" then
            value = blam.null
        else
            value = tonumber(value) or value:gsub("%%", "")
            -- value = tonumber(value) or value:escapep()
        end
    end
    -- local biped = blam.biped(get_dynamic_player())
    local object, objectId = blam.getObject(objectIndex)
    assert(object, "Error, object cannot be found.")
    if object.class == objectClasses.biped then
        object = blam.biped(get_object(objectId))
    elseif object.class == objectClasses.weapon then
        object = blam.weapon(get_object(objectId))
    elseif object.class == objectClasses.vehicle then
        object = blam.vehicle(get_object(objectId))
    end
    if object then
        if key and value then
            object[key] = value
        elseif key then
            consolePrint(key .. ": " .. tostring(nulled(object[key])))
        else
            console_command_info("debug_player_property")
        end
    else
        consolePrint("Error, object cannot be found.")
    end
    return false
end

local function objectNames(keyword)
    consolePrint(consoleColors.warning, "[Index, Id] - Tag -> Address")
    local objectNames = blam.scenario().objectNames
    for nameIndex, name in pairs(objectNames) do
        if keyword then
            if name:find(keyword, 1, true) then
                for objectId, objectIndex in pairs(blam.getObjects()) do
                    local object = blam.object(get_object(objectId))
                    if object and object.nameIndex == nameIndex - 1 then
                        local format = "[%s, %s] - %s -> %s"
                        consolePrint(format:format(objectIndex, objectId, name, nameIndex - 1))
                        break
                    end
                end
            end
        else
            consolePrint(name)
        end
    end
    return false
end

local function gameObjects()
    --consolePrint(consoleColors.warning, "[Index, Id] - Tag -> Address")
    consolePrint("[Index, Id] - Tag -> Address")
    for objectId, objectIndex in pairs(blam.getObjects()) do
        local objectAddress = get_object(objectId)
        local object = blam.object(objectAddress)
        if object then
            local format = "[%s, %s] - %s -> %s"
            local hex = string.format("0x%08X", objectAddress)
            consolePrint(format:format(objectIndex, objectId, blam.getTag(object.tagId).path, hex))
        end
    end
end

local function openWidget(widgetName)
    local widgetTag = findTags(widgetName, engine.tag.classes.uiWidgetDefinition)[1]
    if widgetTag then
        consolePrint("Opening widget: " .. widgetTag.path)
        engine.userInterface.openWidget(widgetTag.path)
    else
        --engine.core.consolePrint(consoleColors.error, "Error, widget tag could not be found.")
        consolePrint("Error, widget tag could not be found.")
    end
    return false
end

local function tagCount()
    consolePrint("Tag count: " .. blam.tagDataHeader.count)
    return false
end

local function deleteObject(objectIndex)
    local objectIndex = tonumber(objectIndex)
    if not objectIndex then
        objectIndex = lastSpawnedObjectHandle
    end
    if objectIndex then
        local object = blam.object(get_object(objectIndex))
        if object then
            delete_object(objectIndex)
            consolePrint("Object successfully deleted!", 0, 1, 0)
            return false
        else
            consolePrint("Error, specified object cannot be found.", 1, 0, 0)
        end
    else
        console_command_info("debug_delete")
    end
    return false
end

local function playerProperty(key, value)
    local player
    if blam.isGameSAPP() then
        player = blam.player(get_player(PlayerIndexExecutingCommand))
    else
        player = blam.player(get_player())
    end
    if player then
        objectProperty(player.objectId, key, value)
        return
    end
    consolePrint("Error, player biped cannot be found.")
end

local function networkObjects(debugSyncedIndex)
    local countColorLevel = blam.consoleColors.success
    local format = "[%s, %s] - %s"
    consolePrint(consoleColors.warning, "[Synced Index, ObjectId] - Tag")
    local networkObjects = {}
    local count = 0
    for syncedIndex = 0, 509 do
        local objectId = blam.getObjectIdBySyncedIndex(syncedIndex)
        if objectId and not isNull(objectId) then
            local object = blam.object(get_object(objectId))
            if object then
                count = count + 1
                if debugSyncedIndex and syncedIndex == tonumber(debugSyncedIndex) then
                    consolePrint(format:format(syncedIndex, objectId, blam.getTag(object.tagId).path))
                    return false
                else
                    networkObjects[syncedIndex] = format:format(syncedIndex, objectId,
                                                                blam.getTag(object.tagId).path)
                end
                -- else
                --    local format = "[%s, %s] - (NULL)"
                --    consolePrint(format:format(syncedIndex, objectId),
                --                table.unpack(blam.consoleColors.error))
            end
        end
    end
    for syncedIndex, object in pairs(networkObjects) do
        consolePrint(object)
    end
    if count > 470 then
        countColorLevel = blam.consoleColors.error
    elseif count > 350 then
        countColorLevel = blam.consoleColors.warning
    end
    consolePrint("Network objects count: " .. count)
    return false
end

local function teleportToObject(objectIndex)
    local objectIndex = tonumber(objectIndex)
    if not objectIndex then
        objectIndex = lastSpawnedObjectHandle
    end
    local object = blam.object(get_object(objectIndex --[[@as number]] ))
    if object then
        local player = blam.biped(get_dynamic_player())
        if player then
            player.x = object.x
            player.y = object.y
            player.z = object.z + 0.5
        end
    else
        consolePrint(consoleColors.error, "Error, object cannot be found.")
    end
    return false
end

local function assignWeapon(objectIndex, weaponObjectIndex)
    local objectIndex = tonumber(objectIndex)
    local weaponObjectIndex = tonumber(weaponObjectIndex)
    if not objectIndex then
        objectIndex = lastSpawnedObjectHandle
    end
    if not weaponObjectIndex then
        weaponObjectIndex = lastSpawnedObjectHandle
    end
    if objectIndex and weaponObjectIndex then
        local object, objectId = blam.getObject(weaponObjectIndex)
        object = blam.biped(get_object(objectId))
        local weaponObject, weaponObjectId = blam.getObject(weaponObjectIndex)
        if object and weaponObject then
            local weapon = blam.weapon(get_object(weaponObjectId))
            if weapon then
                object.firstWeaponObjectId = weaponObjectId
                -- weaponObject.parentObjectId = objectId
                -- weaponObject.ownerId = objectId
                weapon.isOutSideMap = false
                weapon.isInInventory = true
                weapon.isGhost = false
            end
        else
            consolePrint("Error, objects cannot be found.")
        end
    end
    return false
end

commands = {
    -- Game commands
    debug_spawn = {
        description = "<tagClass> <tagKeyword> - Attempt to spawn any object in the map.",
        help = "<tagClass> <tagKeyword>",
        minArgs = 2,
        maxArgs = 2,
        func = spawn
    },
    debug_list = {
        description = "<tagClass> [ <tagName> ] - List all tags of the specified class, optionally filtered by name.",
        help = "<tagClass> [ <tagName> ]",
        minArgs = 1,
        maxArgs = 2,
        func = list
    },
    debug_player_animation = {
        description = "<animIndex> - Play the specified animation index on the player biped.",
        help = "<animIndex>",
        minArgs = 1,
        maxArgs = 1,
        func = playerAnimation
    },
    debug_player_speed = {
        description = "<speed> - Set the player movement speed.",
        help = "<speed>",
        minArgs = 1,
        maxArgs = 1,
        func = playerSpeed
    },
    debug_object_property = {
        description = "<objectIndex | objectId> <property> [ <value> ] - Get or set the specified object property.",
        help = "<objectIndex | objectId> <property> [ <value> ]",
        minArgs = 2,
        maxArgs = 3,
        func = objectProperty
    },
    debug_object_names = {
        description = "[ <objectName> ] - List all object names in the scenario, optionally filtered by name.",
        help = "[ <objectName> ]",
        minArgs = 0,
        maxArgs = 1,
        func = objectNames
    },
    debug_open_widget = {
        description = "<tagKeyword> - Open the specified widget.",
        help = "<tagKeyword>",
        minArgs = 1,
        maxArgs = 1,
        func = openWidget
    },
    debug_list_objects = {description = "List all objects in the map.", func = gameObjects},
    debug_tag_count = {description = "Print the number of tags in the map.", func = tagCount},
    debug_delete_object = {
        description = "<objectIndex | objectId> - Delete the specified object.",
        func = deleteObject
    },
    debug_network_objects = {
        description = "List all network objects in the map or get information about the specified object.",
        help = "[ <syncedIndex> ]",
        minArgs = 0,
        maxArgs = 1,
        func = networkObjects
    },
    debug_player_property = {
        description = "<property> [ <value> ] - Get or set the specified player property.",
        help = "<property> [ <value> ]",
        minArgs = 1,
        maxArgs = 2,
        func = playerProperty
    },
    debug_teleport_to_object = {
        description = "<objectIndex | objectId> - Teleport the player to the specified object.",
        help = "<objectIndex | objectId>",
        minArgs = 1,
        maxArgs = 1,
        func = teleportToObject
    },
    debug_game_objects = {
        description = "Debug all objects in the map.",
        help = "<enable>",
        minArgs = 1,
        maxArgs = 1,
        func = function(enable)
            local enable = luna.bool(enable or false)
            IsDebuggingObjects = enable
            consolePrint(tostring(enable))
        end
    },
    debug_assign_weapon = {
        description = "<objectIndex | objectId> <weaponObjectIndex | weaponObjectId> - Assign the specified weapon to the specified object.",
        help = "<objectIndex | objectId> <weaponObjectIndex | weaponObjectId>",
        minArgs = 2,
        maxArgs = 2,
        func = assignWeapon
    },
    debug_enter_vehicle = {
        description = "Enter the specified vehicle.",
        help = "<objectIndex | objectId> <vehicleObjectIndex | vehicleObjectId>",
        minArgs = 2,
        maxArgs = 2,
        func = enterVehicle
    },
    debug_exit_vehicle = {
        description = "Exit the vehicle.",
        help = "<objectIndex | objectId>",
        minArgs = 1,
        maxArgs = 1,
        func = exitVehicle
    },
    debug_add_weapon_to_inventory = {
        description = "Add the specified weapon to the player's inventory.",
        help = "<unit-index> <weapon-object-index> <action>",
        minArgs = 2,
        maxArgs = 2,
        func = function(unitIndex, weaponObjectIndex, action)
            local _, unitObjectHandle = blam.getObject(tonumber(unitIndex) or -1)
            assert(unitObjectHandle, "Error, unit cannot be found.")
            local _, weaponObjectHandle = blam.getObject(tonumber(weaponObjectIndex) or -1)
            assert(weaponObjectHandle, "Error, weapon object cannot be found.")
            engine.gameState.unitAddWeaponToInventory(unitObjectHandle, weaponObjectHandle, action)
        end
    },
    debug_player_add_weapon_to_inventory = {
        description = "Add the specified weapon to the player's inventory.",
        help = "<weapon-object-index> <action>",
        minArgs = 2,
        maxArgs = 2,
        func = function(weaponObjectIndex, action)
            local player = engine.gameState.getPlayer()
            assert(player, "Error, player cannot be found.")
            local _, weaponObjectHandle = blam.getObject(tonumber(weaponObjectIndex) or -1)
            assert(weaponObjectHandle, "Error, weapon object cannot be found.")
            engine.gameState.unitAddWeaponToInventory(player.objectHandle.value, weaponObjectHandle, tonumber(action))
        end
    },
    debug_delete_all_weapons = {
        description = "Delete all weapons in the map.",
        func = function()
            local player = engine.gameState.getPlayer()
            assert(player, "Error, player cannot be found.")
            engine.gameState.unitDeleteAllWeapons(player.objectHandle.value)
        end
    },
    debug_advanced_camera = {
        description = "Enable advanced camera mode.",
        help = "<enable>",
        minArgs = 1,
        maxArgs = 1,
        func = function(enable)
            local enable = luna.bool(enable or false)
            if not IsDebuggingCamera then
                balltze.chimera.execute_script("debug_camera_save")
                balltze.chimera.execute_script("debug_camera_load")
                IsDebuggingCamera = true
                return false
            end
            balltze.chimera.execute_script("camera_control 0")
            IsDebuggingCamera = false
            consolePrint(tostring(enable))
            return false
        end
    }
}

return commands
