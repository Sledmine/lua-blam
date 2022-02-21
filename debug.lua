clua_version = 2.056

local blam = require "blam"
local tagClasses = blam.tagClasses
local glue = require "glue"
local split = glue.string.split

--- Find the path, index and id of a tag given partial name and tag type
---@param partialName string
---@param searchTagType string
---@return tag tag
local function findTag(partialName, searchTagType)
    for tagIndex = 0, blam.tagDataHeader.count - 1 do
        local tag = blam.getTag(tagIndex)
        if (tag and tag.path:find(partialName, 1, true) and tag.class == searchTagType) then
            return tag
        end
    end
    return nil
end

--- Find the path, index and id of a list of tags given partial name and tag type
---@param partialName string
---@param searchTagType string
---@return tag[] tag
local function findTagsList(partialName, searchTagType)
    local tagsList
    for tagIndex = 0, blam.tagDataHeader.count - 1 do
        local tag = blam.getTag(tagIndex)
        if (tag and tag.path:find(partialName, 1, true) and tag.class == searchTagType) then
            if (not tagsList) then
                tagsList = {}
            end
            tagsList[#tagsList + 1] = tag
        end
    end
    return tagsList
end

function OnCommand(command)
    local args = split(command, " ")
    local action = args[1]
    if (action == "spawn") then
        local tagClass = args[2]
        local tagName = args[3]
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
                    console_out("Error, specified object can not be spawned inside the map.", 1, 0, 0)
                    return false
                end
            end
        end
        console_out("Error, specified object does not exist.", 1, 0, 0)
        return false
    elseif (action == "list") then
        local tagClass = args[2]
        local tagName = args[3] or ""
        local tags = findTagsList(tagName, tagClass)
        if (tags) then
            for _, tag in pairs(tags) do
                console_out(tag.path)
            end
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
    end
end

set_callback("command", "OnCommand")
