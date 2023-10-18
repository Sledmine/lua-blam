clua_version = 2.056
api_version = "1.12.0.0"

local blam = require "blam"
local isNull = blam.isNull
local findTag = blam.findTag
local findTagsList = blam.findTagsList
local tagClasses = blam.tagClasses
local objectClasses = blam.objectClasses
local luna = require "luna"

if blam.isGameSAPP() then
    require "compat53"
end

local commands = require "commands"

-- State
local debugCamera = false
local camera

---On command event handler
---@param playerIndex number
---@param command string
---@param environment number
---@param rconPassword string
function OnCommand(playerIndex, command, environment, rconPassword)
    local playerAdminLevel = 0
    if not blam.isGameSAPP() then
        command = playerIndex --[[@as string]]
        playerAdminLevel = 4
        environment = 1
    else
        PlayerIndexExecutingCommand = playerIndex
        -- Remove double quotes
        command = command:replace('"', "")
        playerAdminLevel = tonumber(get_var(playerIndex, "$lvl"), 10)
    end
    if environment == 1 and playerAdminLevel == 4 then
        command = command:escapep()
        local args = command:split " "
        local action = args[1]

        if action == "debug" then
            local names = table.map(commands, function(v, k)
                return k
            end)
            table.sort(names)
            for _, command in pairs(names) do
                console_out(command .. " - " .. commands[command].description)
            end
            return false
        end
        if action == "localhost" then
            execute_script("connect 127.0.0.1:2302 x")
            return false
        end
        if action == "cam" then
            if not debugCamera then
                execute_script("debug_camera_save")
                execute_script("debug_camera_load")
                debugCamera = true
                return false
            end
            execute_script("camera_control 0")
            debugCamera = false
            return false
        end
        if action == "test" then
            local player = blam.biped(get_dynamic_player())
            local bipedTag = blam.bipedTag(player.tagId)    
            local modelTag = blam.model(bipedTag.model)
            for _, region in pairs(modelTag.regionList) do
                console_out(region.name)
                console_out(region.permutationCount)
                for _, permutation in pairs(region.permutationsList) do
                    console_out(permutation.name)
                end
            end
        end

        if not action:startswith("debug_") then
            action = "debug_" .. action
        end
        -- Shift the arguments
        table.remove(args, 1)

        local command = commands[action]
        if command then
            command.func(table.unpack(args))
            return false
        end
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

function OnScriptLoad()
    set_callback("command", "OnCommand")
end

function OnScriptUnload()
end

function OnError(message)
    print(message)
end

if not blam.isGameSAPP() then
    set_callback("command", "OnCommand")
    set_callback("precamera", "OnPreCamera")
    set_callback("preframe", "OnFrame")
    console_out("Debug script loaded!")
end
