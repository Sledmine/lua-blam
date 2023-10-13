clua_version = 2.056

local blam = require "blam"
local isNull = blam.isNull
local findTag = blam.findTag
local findTagsList = blam.findTagsList
local tagClasses = blam.tagClasses
local objectClasses = blam.objectClasses
local inspect = require "inspect"
local luna = require "luna"

-- State
local debugCamera = false
local camera

local commands = {
    -- Game commands
    debug_spawn = "<tagClass> <tagKeyword> - Attempt to spawn any object in the map.",
    debug_list = "<tagClass> [ <tagName> ] - List all tags of the specified class, optionally filtered by name.",
    debug_localhost = "- Connect to localhost server.",
    debug_map_lan = "<map> - Create a LAN server with the specified map.",
    debug_object_names = "",
    debug_open_widget = "<tagKeyword>",
    debug_set_aspect_ratio = "<widthRatio> <heightRatio>",
    debug_tag_count = "",
    debug_delete_object = "<tagClass> <tagKeyword> - Delete any object in the map by tag class and keyword.",
    debug_network_objects = "",
    -- Player commands
    debug_player_animation = "<animIndex>",
    debug_object_property = "<objectIndex | objectId> <property> [ <value> ]",
    debug_player_properties = "[ <propName> ]",
    debug_player_biped = "<tagKeyword>",
    debug_player_speed = "<speed>",
    debug_network_delay = "<delay>"
}

local function nulled(value)
    if isNull(value) then
        return "NULL"
    end
    return value
end

local function console_command_info(command)
    console_out(command .. ": " .. commands[command])
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

local lastSpawnedObjectId = nil

---On command event handler
---@param command string
function OnCommand(command)
    command = command:escapep()
    local args = command:split " "
    local action = args[1]
    if action:startswith("debug_") then
        action = action:replace("debug_", "")
    end
    if action == "enter_vehicle" then
        require"mods.balltze".unit_enter_vehicle(blam.player(get_player()).objectId,
                                                 lastSpawnedObjectId, 0)
        return false
    elseif action == "debug" then
        local names = table.map(commands, function(v, k)
            return k
        end)
        table.sort(names)
        for _, command in pairs(names) do
            console_command_info(command)
        end
        return false
    elseif action == "spawn" then
        local tagClass = tagClasses[args[2]] or args[2]
        local tagName = args[3]
        if tagClass and tagName then
            local tag = findTag(tagName, tagClass)
            if tag then
                local biped = blam.biped(get_dynamic_player())
                assert(biped, "Error, player biped cannot be found.")
                local objectX = biped.x + biped.cameraX * 3
                local objectY = biped.y + biped.cameraY * 3
                local objectZ = biped.z + biped.cameraZ * 3
                local objectId = spawn_object(tag.id, objectX, objectY, objectZ)
                if objectId then
                    local object = blam.object(get_object(objectId))
                    if object and not object.isOutSideMap then
                        console_out("Object successfully spawned!", 0, 1, 0)
                        lastSpawnedObjectId = objectId
                        return false
                    else
                        delete_object(objectId)
                        console_out("Error, specified object can not be spawned inside the map.", 1,
                                    0, 0)
                        return false
                    end
                end
            end
        else
            console_command_info("debug_spawn")
            return false
        end
        console_out("Error, specified object does not exist.", 1, 0, 0)
        return false
    elseif action == "list" then
        local tagClass = tagClasses[args[2]] or args[2]
        local tagName = args[3] or ""
        if tagClass then
            local tags = findTagsList(tagName, tagClass)
            if tags then
                for _, tag in pairs(tags) do
                    console_out(("[%s, %s] - %s"):format(tag.index, tag.id, tag.path))
                end
                return false
            end
        else
            console_command_info("debug_list")
            return false
        end
        console_out("Error, no tags were found.")
        return false
    elseif action == "player_animation" then
        local animationIndex = tonumber(args[2])
        assert(animationIndex, "Error, animation index must be a number.")
        local biped = blam.biped(get_dynamic_player())
        if biped then
            biped.animation = animationIndex
            biped.animationFrame = 0
        end
    elseif action == "localhost" then
        execute_script("connect 127.0.0.1:2302 x")
        return false
    elseif action == "lan" then
        local mapName = args[2]
        local gameType = args[3]
        if mapName then
            if not gameType then
                execute_script("sv_map " .. mapName .. " slayer")
            else
                execute_script("sv_map " .. mapName .. " " .. gameType)
            end
        else
            console_out("Error, no map name was specified.", 1, 0, 0)
        end
    elseif action == "player_speed" then
        local newSpeed = tonumber(args[2])
        assert(newSpeed, "Error, speed must be a number.")
        local player = blam.player(get_player())
        if player then
            player.speed = newSpeed
        end
        return false
    elseif action == "object_property" then
        local objectIndex = tonumber(args[2])
        assert(objectIndex, "Error, object index must be a number.")
        local key = args[3]
        local value = args[4] --[[@as string|number|any]]
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
    elseif action == "player_properties" then
        local filter = args[2]
        local biped = blam.biped(get_dynamic_player())
        if not biped then
            console_out("Error, player biped cannot be found.", 1, 0, 0)
            return false
        end
        local keys = table.keys(blam.dumpObject(biped)) --[=[@as string[]]=]
        table.sort(keys)
        if filter then
            keys = table.filter(keys, function(key)
                return key:find(filter, 1, true) ~= nil
            end)
        end
        for _, key in pairs(keys) do
            console_out(key)
        end
        return false
    elseif action == "player_biped" then
        local bipedName = args[2]
        local bipedTag = findTag(bipedName, tagClasses.biped)
        if bipedTag then
            local globals = blam.globalsTag()
            assert(globals, "Error, globals tag cannot be found.")
            local newMultiplayerInformation = globals.multiplayerInformation
            newMultiplayerInformation[1].unit = bipedTag.id
            globals.multiplayerInformation = newMultiplayerInformation
            local player = blam.player(get_player())
            if player and not isNull(player.objectId) then
                delete_object(player.objectId)
            end
            return false
        else
            console_out("Error, biped tag cannot be found.", table.unpack(blam.consoleColors.error))
            return false
        end
        cmdinfo("debug_player_biped")
        return false
    elseif action == "object_names" then
        local objectName = args[2]
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
    elseif action == "open_widget" then
        local widgetName = args[2]
        local widgetTag = findTag(widgetName, tagClasses.uiWidgetDefinition)
        if widgetTag then
            load_ui_widget(widgetTag.path)
            -- console_out(widgetTag.path .. " " .. widgetTag.id)
            -- openWidget(widgetTag.id, true)
        else
            console_out("Error, widget tag could not be found.",
                        table.unpack(blam.consoleColors.error))
        end
        return false
    elseif action == "set_aspect_ratio" then
        local widthRatio = args[2]
        local heightRatio = args[3]
        if widthRatio and heightRatio then
            local harmony = require "mods.harmony"
            harmony.menu.set_aspect_ratio(tonumber(widthRatio), tonumber(heightRatio))
        else
            cmdinfo("debug_set_aspect_ratio")
        end
        return false
    elseif action == "tag_count" then
        console_out("Tag count: " .. blam.tagDataHeader.count)
        return false
    elseif action == "objects" then
        console_out("[Index, Id] - Tag -> Address", table.unpack(blam.consoleColors.warning))
        for objectId, objectIndex in pairs(blam.getObjects()) do
            local objectAddress = get_object(objectIndex)
            local object = blam.object(objectAddress)
            if object then
                local format = "[%s, %s] - %s -> %s"
                local hex = string.format("0x%08X", objectAddress)
                console_out(
                    format:format(objectIndex, objectId, blam.getTag(object.tagId).path, hex))
                if object.class == objectClasses.weapon then
                    local weapon = blam.weapon(objectAddress)
                    if weapon then
                        console_out("Weapon owner: " .. getTagFromObject(weapon.ownerObjectId))
                    end
                end
            end
        end
        return false
    elseif action == "delete_object" then
        local tagClass = tagClasses[args[2]] or args[2]
        local tagName = args[3] or ""
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
            cmdinfo("debug_delete")
        end
        return false
    elseif action == "network_objects" then
        local countColorLevel = blam.consoleColors.success
        console_out("[Synced Index, ID] - Tag", table.unpack(blam.consoleColors.warning))
        local count = 0
        for syncedIndex = 0, 509 do
            local objectId = blam.getObjectIdBySincedIndex(syncedIndex)
            if objectId then
                count = count + 1
                local object = blam.object(get_object(objectId))
                if object then
                    local format = "[%s, %s] - %s"
                    console_out(format:format(syncedIndex, objectId, blam.getTag(object.tagId).path))
                else
                    local format = "[%s, %s] - (NULL)"
                    console_out(format:format(syncedIndex, objectId),
                                table.unpack(blam.consoleColors.error))
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
    elseif action == "network_delay" then
        local delay = args[2]
        if delay then
            os.execute("ping 127.0.0.1 -n " .. delay .. " > NUL")
        else
            cmdinfo("debug_network_delay")
        end
        return false
    elseif action == "test" then
        local playerBiped = blam.biped(get_dynamic_player())
        assert(playerBiped, "Error, player biped cannot be found.")
        local biped = blam.bipedTag(playerBiped.tagId)
        assert(biped, "Error, biped tag cannot be found.")
        local model = blam.model(biped.model)
        assert(model, "Error, biped model cannot be found.")
        for i = 1, model.regionCount do
            console_out("Model path: " .. model.regionList[i].name)
            console_out("Model path: " .. model.regionList[i].permutationCount)
        end
        -- console_out("Model path: " .. model.regionList[1].permutationsList[1].name)
    elseif action == "cam" then
        if not debugCamera then
            execute_script("debug_camera_save")
            execute_script("debug_camera_load")
            debugCamera = true
            return false
        end
        execute_script("camera_control 1")
        debugCamera = false
        return false
    end
end

function OnPreCamera(x, y, z, fov, vX, vY, vZ, v2X, v2Y, v2Z)
    camera = {
        x = x,
        y = y,
        z = z,
        fov = fov,
        vX = vX,
        vY = vY,
        vZ = vZ,
        v2X = v2X,
        v2Y = v2Y,
        v2Z = v2Z
    }
    return x, y, z, fov, vX, vY, vZ, v2X, v2Y, v2Z
end

local bounds = {left = 0, top = 460, right = 640, bottom = 480}
local textColor = {1, 1, 1, 1}
function OnFrame()
    if debugCamera then
        local yaw, pitch, roll = blam.getRotationFromVectors({
            x = camera.vX,
            y = camera.vY,
            z = camera.vZ
        }, {x = camera.v2X, y = camera.v2Y, z = camera.v2Z})
        local coordinates = "Camera: " .. "X: " .. camera.x .. " Y: " .. camera.y .. " Z: " ..
                                camera.z
        local angles = "Yaw: " .. yaw .. " Pitch: " .. pitch .. " Roll: " .. roll
        draw_text(coordinates, bounds.left + 16, bounds.top, bounds.left + 400, bounds.bottom,
                  "console", "left", table.unpack(textColor))
        draw_text(angles, bounds.left + 16, bounds.top - 16, bounds.left + 400, bounds.bottom,
                  "console", "left", table.unpack(textColor))
    end
end

set_callback("command", "OnCommand")
set_callback("precamera", "OnPreCamera")
set_callback("preframe", "OnFrame")
