local blam = require "blam"
local tagClasses = blam.tagClasses
local objectClasses = blam.objectClasses
local findTag = blam.findTag
local findTagsList = blam.findTagsList
local isNull = blam.isNull

local commands = {}

local originalConsoleOut = console_out

local function console_out(...)
    originalConsoleOut(...)
    if blam.isGameSAPP() then
        local args = {...}
        local message = args[1]
        rprint(PlayerIndexExecutingCommand, message)
    end
end

local lastSpawnedObjectId = nil

local function console_command_info(command)
    console_out(command .. ": " .. commands[command].description)
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

local function getTagFromObject(objectId)
    if isNull(objectId) then
        return "NULL"
    end
    local object = blam.object(get_object(objectId))
    if object then
        return getTagName(object.tagId)
    end
end

local function enter_vehicle()
    require"mods.balltze".unit_enter_vehicle(blam.player(get_player()).objectId,
                                             lastSpawnedObjectId, 0)
    return false
end

local function spawn(tagClass, tagName)
    local tagClass = tagClasses[tagClass] or tagClass
    local tagName = tagName or ""
    if not (tagClass and tagName) then
        console_command_info("debug_spawn")
        return false
    end
    local tag = findTag(tagName, tagClass)
    if tag then
        local biped
        if blam.isGameSAPP() then
            biped = blam.biped(get_dynamic_player(PlayerIndexExecutingCommand))
        else
            biped = blam.biped(get_dynamic_player())
        end
        assert(biped, "Error, player biped cannot be found.")
        local objectX = biped.x + biped.cameraX * 3
        local objectY = biped.y + biped.cameraY * 3
        local objectZ = biped.z + biped.cameraZ * 3
        local objectId = spawn_object(tagClass, tag.path, objectX, objectY, objectZ)
        if objectId then
            local object = blam.object(get_object(objectId))
            if object and not object.isOutSideMap then
                console_out("Object successfully spawned!", 0, 1, 0)
                lastSpawnedObjectId = objectId
                return false
            else
                delete_object(objectId)
                console_out("Error, specified object can not be spawned inside the map.", 1, 0, 0)
                return false
            end
        end
    end
    console_out("Error, specified object tag cannot be found.", 1, 0, 0)
end

local function list(tagClass, tagName)
    local tagClass = tagClasses[tagClass] or tagClass
    local tagName = tagName or ""
    if tagClass then
        local tags = findTagsList(tagName, tagClass)
        if tags then
            for _, tag in pairs(tags) do
                console_out(("[Index: %s, ID: %s] - %s"):format(tag.index, tag.id, tag.path))
            end
            return false
        end
    else
        console_command_info("debug_list")
        return false
    end
    console_out("Error, no tags were found.")
end

local function playerAnimation(animIndex)
    local animationIndex = tonumber(animIndex)
    assert(animationIndex, "Error, animation index must be a number.")
    local biped = blam.biped(get_dynamic_player())
    if biped then
        biped.animation = animationIndex
        biped.animationFrame = 0
    end
end

local function playerSpeed()
    local newSpeed = tonumber(speed)
    assert(newSpeed, "Error, speed must be a number.")
    local player = blam.player(get_dynamic_player())
    if player then
        player.speed = newSpeed
    end
end

local function objectProperty(objectIndex, key, value)
    local objectIndex = tonumber(objectIndex)
    if not objectIndex then
        objectIndex = lastSpawnedObjectId
    end
    if value then
        if value == "LAST_OBJECT" then
            value = lastSpawnedObjectId
        elseif value == "NULL" then
            value = blam.null
        else
            value = tonumber(value) or value:gsub("%%", "")
            -- value = tonumber(value) or value:escapep()
        end
    end
    -- local biped = blam.biped(get_dynamic_player())
    local object = blam.object(get_object(objectIndex))
    assert(object, "Error, object cannot be found.")
    if object.class == objectClasses.biped then
        object = blam.biped(get_object(objectIndex))
    elseif object.class == objectClasses.weapon then
        object = blam.weapon(get_object(objectIndex))
    end
    if object then
        if key and value then
            object[key] = value
        elseif key then
            console_out(key .. ": " .. nulled(object[key]))
        else
            console_command_info("debug_player_property")
        end
    else
        console_out("Error, player biped cannot be found.", 1, 0, 0)
    end
    return false
end

local function objectNames(objectName)
    local objectNames = blam.scenario().objectNames
    for _, object in pairs(objectNames) do
        if objectName then
            if object:find(objectName, 1, true) then
                console_out(object)
                break
            end
        else
            console_out(object)
        end
    end
    return false
end

local function gameObjects()
    console_out("[Index, Id] - Tag -> Address", table.unpack(blam.consoleColors.warning))
    for objectId, objectIndex in pairs(blam.getObjects()) do
        local objectAddress = get_object(objectIndex)
        local object = blam.object(objectAddress)
        if object then
            local format = "[%s, %s] - %s -> %s"
            local hex = string.format("0x%08X", objectAddress)
            console_out(format:format(objectIndex, objectId, blam.getTag(object.tagId).path, hex))
            if object.class == objectClasses.weapon then
                local weapon = blam.weapon(objectAddress)
                if weapon then
                    console_out("Weapon owner: " .. getTagFromObject(weapon.ownerObjectId))
                end
            end
        end
    end
end

local function openWidget(widgetName)
    local widgetTag = findTag(widgetName, tagClasses.uiWidgetDefinition)
    if widgetTag then
        load_ui_widget(widgetTag.path)
        -- console_out(widgetTag.path .. " " .. widgetTag.id)
        -- openWidget(widgetTag.id, true)
    else
        console_out("Error, widget tag could not be found.", table.unpack(blam.consoleColors.error))
    end
    return false
end

local function tagCount()
    console_out("Tag count: " .. blam.tagDataHeader.count)
    return false
end

local function deleteObject(tagClass, tagName)
    local tagClass = tagClasses[tagClass] or tagClass
    local tagName = tagName or ""
    if tagClass and tagName then
        for _, objectIndex in pairs(blam.getObjects()) do
            local object = blam.object(get_object(objectIndex))
            if object then
                local tag = blam.getTag(object.tagId)
                if tag and tag.class == tagClass and tag.path:find(tagName, 1, true) then
                    console_out("Deleting object: " .. tag.path)
                    delete_object(objectIndex)
                end
            end
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
    console_out("Error, player biped cannot be found.", 1, 0, 0)
end

local function networkObjects()
    local countColorLevel = blam.consoleColors.success
    console_out("[Synced Index, ID] - Tag", table.unpack(blam.consoleColors.warning))
    local count = 0
    for syncedIndex = 0, 509 do
        local objectId = blam.getObjectIdBySincedIndex(syncedIndex)
        if objectId and not isNull(objectId) then
            local object = blam.object(get_object(objectId))
            if object then
                count = count + 1
                local format = "[%s, %s] - %s"
                console_out(format:format(syncedIndex, objectId, blam.getTag(object.tagId).path))
                -- else
                --    local format = "[%s, %s] - (NULL)"
                --    console_out(format:format(syncedIndex, objectId),
                --                table.unpack(blam.consoleColors.error))
            end
        end
    end
    if count > 470 then
        countColorLevel = blam.consoleColors.error
    elseif count > 350 then
        countColorLevel = blam.consoleColors.warning
    end
    console_out("Network objects count: " .. count, table.unpack(countColorLevel))
    return false
end

local function networkDelay(delay)
    local delay = tonumber(delay)
    if delay then
        os.execute("ping 127.0.0.1 -n " .. delay .. " > NUL")
    else
        console_command_info("debug_network_delay")
    end
end

commands = {
    -- Game commands
    debug_spawn = {
        description = "<tagClass> <tagKeyword> - Attempt to spawn any object in the map.",
        func = spawn
    },
    debug_list = {
        description = "<tagClass> [ <tagName> ] - List all tags of the specified class, optionally filtered by name.",
        func = list
    },
    debug_player_animation = {
        description = "<animIndex> - Play the specified animation index on the player biped.",
        func = playerAnimation
    },
    debug_player_speed = {
        description = "<speed> - Set the player movement speed.",
        func = playerSpeed
    },
    debug_object_property = {
        description = "<objectIndex | objectId> <property> [ <value> ] - Get or set the specified object property.",
        func = objectProperty
    },
    debug_object_names = {
        description = "[ <objectName> ] - List all object names in the scenario, optionally filtered by name.",
        func = objectNames
    },
    debug_open_widget = {
        description = "<tagKeyword> - Open the specified widget.",
        func = openWidget
    },
    debug_game_objects = {description = "List all objects in the map.", func = gameObjects},
    debug_tag_count = {description = "Print the number of tags in the map.", func = tagCount},
    debug_delete_object = {
        description = "<tagClass> <tagKeyword> - Delete any object in the map by tag class and keyword.",
        func = deleteObject
    },
    debug_network_objects = {
        description = "List all network objects in the map.",
        func = networkObjects
    },
    debug_network_delay = {
        description = "<delay> - Delay the network for the specified amount of milliseconds.",
        func = networkDelay
    },
    debug_player_property = {
        description = "<property> [ <value> ] - Get or set the specified player property.",
        func = playerProperty
    },
}

return commands
