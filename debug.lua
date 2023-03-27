clua_version = 2.056

local blam = require "blam"
local isNull = blam.isNull
local findTag = blam.findTag
local findTagsList = blam.findTagsList
local tagClasses = blam.tagClasses
local glue = require "glue"
local split = glue.string.split
local escape = glue.string.esc
local inspect = require "inspect"
local luna = require "luna"

local commands = {
    spawn = "Usage: spawn <tagClass> <tagKeyword>",
    list = "Usage: list <tagClass> [ <tagName> ]",
    anim = "Usage: anim <animIndex>",
    localhost = "Usage: localhost",
    lan = "Usage: lan <map>",
    speed = "Usage: speed <speed>",
    plprop = "Usage: plprop <propName> <propValue>",
    plbiped = "Usage: plbiped <tagKeyword>",
    object_names = "Usage: object_names",
    open_widget = "Usage: open_widget <tagKeyword>",
    set_aspect_ratio = "Usage: set_aspect_ratio <widthRatio> <heightRatio>",
    tagcount = "Usage: tagcount",
    delete = "Usage: delete <tagClass> <tagKeyword>"
}

function OnCommand(command)
    command = escape(command)
    local args = split(command, " ")
    local action = args[1]
    if (action == "spawn") then
        local tagClass = tagClasses[args[2]] or args[2]
        local tagName = args[3]
        if (tagClass and tagName) then
            local tag = findTag(tagName, tagClass)
            if (tag) then
                local playerBiped = blam.biped(get_dynamic_player())
                local objectX = playerBiped.x + playerBiped.cameraX * 3
                local objectY = playerBiped.y + playerBiped.cameraY * 3
                local objectZ = playerBiped.z + playerBiped.cameraZ * 3
                local objectId = spawn_object(tag.id, objectX, objectY, objectZ)
                if (objectId) then
                    local object = blam.object(get_object(objectId))
                    if (object and not object.isOutSideMap) then
                        console_out("Object successfully spawned!", 0, 1, 0)
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
            console_out(commands.spawn)
            return false
        end
        console_out("Error, specified object does not exist.", 1, 0, 0)
        return false
    elseif (action == "list") then
        local tagClass = tagClasses[args[2]] or args[2]
        local tagName = args[3] or ""
        if (tagClass) then
            local tags = findTagsList(tagName, tagClass)
            if (tags) then
                for _, tag in pairs(tags) do
                    console_out(tag.path)
                end
                return false
            end
        else
            console_out(commands.list)
            return false
        end
        console_out("Error, no tags were found.")
        return false
    elseif (action == "anim") then
        local animationIndex = args[2]
        local playerBiped = blam.biped(get_dynamic_player())
        if (playerBiped) then
            playerBiped.animation = animationIndex
            playerBiped.animationFrame = 0
        end
    elseif (action == "localhost") then
        execute_script("connect 127.0.0.1:2302 x")
        return false
    elseif (action == "lan") then
        local mapName = args[2]
        local gameType = args[3]
        if (mapName) then
            if (not gameType) then
                execute_script("sv_map " .. mapName .. " slayer")
            else
                execute_script("sv_map " .. mapName .. " " .. gameType)
            end
        else
            console_out("Error, no map name was specified.", 1, 0, 0)
        end
    elseif (action == "speed") then
        local newSpeed = args[2] or 2
        local player = blam.player(get_player())
        if (player) then
            player.speed = newSpeed
        end
        return false
    elseif (action == "plprop") then
        local key = args[2]
        local value = args[3]
        if value then
            value = tonumber(value) or value:gsub("%%", "")
        end
        local playerBiped = blam.biped(get_dynamic_player())
        if (playerBiped) then
            if key and value then
                playerBiped[key] = value
            elseif key then
                console_out(playerBiped[key])
            else
                console_out(commands.plprop)
            end
        else
            console_out("Error, player biped cannot be found.", 1, 0, 0)
        end
        return false
    elseif action == "plprops" then
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
    elseif (action == "plbiped") then
        local bipedName = args[2]
        local bipedTag = findTag(bipedName, tagClasses.biped)
        if (bipedTag) then
            local globals = blam.globalsTag()
            local newMultiplayerInformation = globals.multiplayerInformation
            newMultiplayerInformation[1].unit = bipedTag.id
            globals.multiplayerInformation = newMultiplayerInformation
            local player = blam.player(get_player())
            if (player and not isNull(player.objectId)) then
                delete_object(player.objectId)
            end
            return false
        else
            console_out("Error, biped tag cannot be found.", table.unpack(blam.consoleColors.error))
            return false
        end
        console_out("Usage: plbiped <bipedTagName>")
        return false
    elseif (action == "object_names") then
        local objectName = args[2]
        local objectNames = blam.scenario().objectNames
        for _, object in pairs(objectNames) do
            if objectName then
                if (object:find(objectName)) then
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
            console_out("Usage: set_aspect_ratio <widthRatio> <heightRatio>")
        end
        return false
    elseif (action == "tagcount") then
        console_out("Tag count: " .. blam.tagDataHeader.count)
        return false
    elseif (action == "debug") then
        for k, v in pairs(commands) do
            console_out(k .. " - " .. v)
        end
        return false
    elseif action == "delete" then
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
            console_out("Usage: delete <tagClass> <tagKeyword>")
        end
        return false
    end
end

set_callback("command", "OnCommand")
