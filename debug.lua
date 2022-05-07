clua_version = 2.056

local blam = require "blam"
local isNull = blam.isNull
local findTag = blam.findTag
local findTagsList = blam.findTagsList
local tagClasses = blam.tagClasses
local glue = require "glue"
local split = glue.string.split
local escape = glue.string.esc

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
                    if (not object.isOutSideMap) then
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
            console_out("Usage: spawn <tagClass> <tagKeyword>")
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
            console_out("Usage: <tagClass> [ <tagName> ]")
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
    elseif (action == "local") then
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
        local value = tonumber(args[3]) or args[3]
        local playerBiped = blam.biped(get_dynamic_player())
        if (key and value) then
            if (playerBiped) then
                playerBiped[key] = value
            end
        else
            console_out("Usage: property <key> <value>")
            console_out(table.concat(glue.keys(blam.dumpObject(playerBiped)), ", "))
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
    end
end

set_callback("command", "OnCommand")
