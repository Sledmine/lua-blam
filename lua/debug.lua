local blam = require "blam"
local objectClasses = blam.objectClasses
local tagClasses = blam.tagClasses
local isNull = blam.isNull
local luna = require "luna"
local inspect = require "inspect"
local balltze = Balltze
local engine = Engine

---@type Logger
local logger

local commands = require "debug.commands"
local game = require "debug.game"

local textDrawQueue = {}
IsDebuggingCamera = false
IsDebuggingObjects = false
local camera = {x = 0, y = 0, z = 0, fov = 0, vX = 0, vY = 0, vZ = 0, v2X = 0, v2Y = 0, v2Z = 0}
local gizmos = {}
local gizmo

function PluginMetadata()
    return {
        name = "Debug",
        author = "Sledmine",
        version = "1.0.0",
        targetApi = "1.1.0",
        reloadable = true
    }
end

local function getRenderedUIWidgetTagId()
    local isPlayerOnMenu = read_byte(blam.addressList.gameOnMenus) == 0
    if isPlayerOnMenu then
        local widgetIdAddress = read_dword(blam.addressList.currentWidgetIdAddress)
        if widgetIdAddress and widgetIdAddress ~= 0 then
            local widgetId = read_dword(widgetIdAddress)
            return widgetId
        end
    end
    return nil
end

local simpleTemplate = [[Index: {objectIndex} | Server: {syncedIndex}
Object: {objectName}]]

local objectTemplate = simpleTemplate .. "\n" ..
                           [[Weapon Slot: {weaponSlot}]]

--local objectTemplate = [[({class})
--Index: {objectIndex} | ID: {objectId} | Adress: {adress} | Server: {syncedIndex} | Health: {health} | Shield: {shield} | isGhost: {isGhost}
--Parent Index: {parentObjectId} | Team: {team} | Player Index: {playerId} | Owner Index: {ownerId} | Network Role Class: {networkRoleClass}
--X: {rX} | Y: {rY} | Z: {rZ}
--Object: {objectName}]]

local sceneryTemplate =
    [[Index: {objectIndex} | Health: {health} | Shield: {shield} | Permutations: [{regionPermutation1}, {regionPermutation2}, {regionPermutation3}, {regionPermutation4}, {regionPermutation5}, {regionPermutation6}, {regionPermutation7}, {regionPermutation8}]
X: {x} | Y: {y} | Z: {z} | Yaw: {yaw} | Pitch: {pitch} | Roll: {roll}
Object: {objectName}]]

local vehicleTemplate = objectTemplate .. "\n" ..
                            [[thrust: {thrust} | hover: {hover} | speed: {speed} | respawnTime: {respawnTime}
isHovering: {isHovering} | isTireBlur: {isTireBlur} | isJumping: {isJumping} | isCrouched: {isCrouched}]]

local parentChildScreenOffset = 80

local function debugEngine()
    if IsDebuggingObjects then
        for objectId, objectIndex in pairs(blam.getObjects()) do
            local object = blam.object(get_object(objectId))
            -- local objectShouldBeDebugged = object and not object.isApparentlyDead and
            local objectShouldBeDebugged = object and
                                               (object.class == objectClasses.biped or object.class ==
                                                   objectClasses.vehicle or object.class ==
                                                   objectClasses.weapon)
            if object and objectShouldBeDebugged then
                local isObjectVehicle = object.class == objectClasses.vehicle
                local isObjectBiped = object.class == objectClasses.biped
                local isObjectScenery = object.class == objectClasses.scenery
                if isObjectVehicle then
                    object = blam.vehicle(get_object(objectId))
                    assert(object, "Vehicle not found!")
                end

                -- Player object perspective
                local player = blam.biped(get_dynamic_player())
                local target = blam.getAbsoluteObjectCoordinates(object)
                local final = blam.getAbsoluteObjectCoordinates(object)

                local isWorthDrawing = false
                local font = "small"
                local color = {0.4, 1, 1, 1}
                local distance = 0
                if player then
                    distance = game.getVectorsDistance(player --[[@as vector3D]] , target)
                    local coords = blam.getAbsoluteObjectCoordinates(player)
                    final.x = target.x - coords.x
                    final.y = target.y - coords.y
                    final.z = target.z - coords.z
                    if distance < 30 then
                        isWorthDrawing = true
                    end
                    if not isNull(object.playerId) then
                        isWorthDrawing = true
                    end
                end
                -- if not gizmos[objectId] then
                --    if isNull(object.playerId) then
                --        local absolute = blam.getAbsoluteObjectCoordinates(object)
                --        if gizmo then
                --            console_out("Spawning gizmo for object " .. objectId)
                --            gizmos[objectId] = spawn_object(gizmo.id, absolute.x, absolute.y,
                --                                            absolute.z)
                --        end
                --    end
                -- else
                --    local absolute = blam.getAbsoluteObjectCoordinates(object)
                --    local gizmoObject = blam.object(get_object(gizmos[objectId]))
                --    if gizmoObject then
                --        gizmoObject.x = absolute.x
                --        gizmoObject.y = absolute.y
                --        gizmoObject.z = absolute.z
                --        gizmoObject.vX = object.vX
                --        gizmoObject.vY = object.vY
                --        gizmoObject.vZ = object.vZ
                --        gizmoObject.v2X = object.v2X
                --        gizmoObject.v2Y = object.v2Y
                --        gizmoObject.v2Z = object.v2Z
                --    end
                -- end

                if blam.getCameraType() == blam.cameraTypes.devcam or blam.getCameraType() ==
                    blam.cameraTypes.scripted then
                    distance = game.getVectorsDistance(camera, target)
                    if distance < 20 then
                        isWorthDrawing = true
                    end
                    final.x = target.x - camera.x
                    final.y = target.y - camera.y
                    final.z = target.z - camera.z
                end
                if distance < 5 then
                    font = "large"
                    color = {0.8, 1, 1, 1}
                end
                if distance < 1 then
                    font = "ticker"
                    color = {1, 1, 1, 1}
                end

                if isObjectBiped and (object.isApparentlyDead or object.health <= 0) then
                    color = {color[1], 1, 0, 0}
                end

                if isWorthDrawing then
                    local screenSpaceX, screenSpaceY, screenSpaceZ =
                        game.worldCoordinatesToScreenSpace(final.x, final.y, final.z, 0, 0, 0,
                                                             camera.vX, camera.vY, camera.vZ,
                                                             game.getVerticalFov(camera.fov))

                    -- Check if the object is in front of the camera
                    if screenSpaceZ < 1 then
                        local objectName = blam.getTag(object.tagId).path
                        if not isNull(object.nameIndex) then
                            objectName = blam.scenario().objectNames[object.nameIndex + 1]
                        end
                        if object.isGhost then
                            screenSpaceY = screenSpaceY + 125
                        end

                        local syncedIndex
                        for i = 0, 509 do
                            local syncedObjectId = blam.getObjectIdBySyncedIndex(i)
                            if syncedObjectId == objectId then
                                syncedIndex = i
                                break
                            end
                        end
                        local parentObjectId
                        if not isNull(object.parentObjectId) then
                            color = {color[1], 1, 0, 1}
                            if player then
                                local coords = blam.getAbsoluteObjectCoordinates(player)
                                local targetObject = blam.object(get_object(object.parentObjectId))
                                assert(targetObject, "Parent object not found!")
                                local target = blam.getAbsoluteObjectCoordinates(targetObject)
                                final.x = target.x - coords.x
                                final.y = target.y - coords.y
                                final.z = target.z - coords.z
                                if get_object(objectId) == get_dynamic_player() then
                                    isWorthDrawing = false
                                end
                            end
                            if blam.getCameraType() == blam.cameraTypes.devcam or
                                blam.getCameraType() == blam.cameraTypes.scripted then
                                if game.getVectorsDistance(camera, target) < 20 then
                                    isWorthDrawing = true
                                end
                                final.x = target.x - camera.x
                                final.y = target.y - camera.y
                                final.z = target.z - camera.z
                            end
                            local parentScreenSpaceX, parentScreenSpaceY, parentScreenSpaceZ =
                                game.worldCoordinatesToScreenSpace(final.x, final.y, final.z, 0,
                                                                     0, 0, camera.vX, camera.vY,
                                                                     camera.vZ,
                                                                     game.getVerticalFov(
                                                                         camera.fov))
                            screenSpaceY = parentScreenSpaceY - parentChildScreenOffset
                            for k, v in pairs(textDrawQueue) do
                                if v.y == screenSpaceY then
                                    screenSpaceY = screenSpaceY - parentChildScreenOffset
                                    color = {color[1], 1, 1, 0}
                                end
                            end
                            parentObjectId = blam.getIndexById(object.parentObjectId)
                        end
                        local team
                        if not isNull(object.team) then
                            team = object.team
                        end
                        local playerId
                        if not isNull(object.playerId) then
                            playerId = blam.getIndexById(object.playerId)
                        end
                        local ownerId
                        if not isNull(object.ownerId) then
                            ownerId = blam.getIndexById(object.ownerId)
                        end
                        local networkRoleClass
                        if not isNull(object.networkRoleClass) then
                            networkRoleClass =
                                table.flip(blam.objectNetworkRoleClasses)[object.networkRoleClass]
                        end
                        local absoluteObjectCoordinates = blam.getAbsoluteObjectCoordinates(object)
                        local template = simpleTemplate
                        if isObjectVehicle then
                            template = vehicleTemplate
                        elseif isObjectBiped then
                            template = objectTemplate
                        elseif isObjectScenery then
                            template = sceneryTemplate
                        end

                        local yaw, pitch, roll = blam.getObjectRotation(object)

                        local debugValues = {
                            class = table.flip(objectClasses)[object.class],
                            adress = string.format("0x%X", object.address),
                            objectIndex = objectIndex,
                            objectId = objectId,
                            objectName = objectName,
                            health = string.format("%.2f", object.health),
                            shield = string.format("%.2f", object.shield),
                            syncedIndex = tostring(syncedIndex or "LOCAL"),
                            x = string.format("%.2f", absoluteObjectCoordinates.x),
                            y = string.format("%.2f", absoluteObjectCoordinates.y),
                            z = string.format("%.2f", absoluteObjectCoordinates.z),
                            rX = string.format("%.8f", object.x),
                            rY = string.format("%.8f", object.y),
                            rZ = string.format("%.8f", object.z),

                            parentObjectId = parentObjectId or "NULL",
                            team = team or "NULL",
                            playerId = playerId or "NULL",
                            ownerId = ownerId or "NULL",
                            networkRoleClass = networkRoleClass or "NULL",
                            isGhost = tostring(object.isGhost),
                            regionPermutation1 = tostring(object.regionPermutation1),
                            regionPermutation2 = tostring(object.regionPermutation2),
                            regionPermutation3 = tostring(object.regionPermutation3),
                            regionPermutation4 = tostring(object.regionPermutation4),
                            regionPermutation5 = tostring(object.regionPermutation5),
                            regionPermutation6 = tostring(object.regionPermutation6),
                            regionPermutation7 = tostring(object.regionPermutation7),
                            regionPermutation8 = tostring(object.regionPermutation8),
                            yaw = string.format("%.2f", yaw),
                            pitch = string.format("%.2f", pitch),
                            roll = string.format("%.2f", roll),
                        }

                        if isObjectVehicle then
                            debugValues = table.merge(debugValues, {
                                thrust = string.format("%.2f", object.thrust),
                                hover = string.format("%.2f", object.hover),
                                speed = string.format("%.2f", object.speed),
                                respawnTime = object.respawnTime,
                                isHovering = tostring(object.isHovering),
                                isTireBlur = tostring(object.isTireBlur),
                                isJumping = tostring(object.isJumping),
                                isCrouched = tostring(object.isCrouched)
                            })
                        end

                        if isObjectBiped then
                            object = blam.biped(get_object(objectId))
                            assert(object, "Biped not found!")
                            debugValues = table.merge(debugValues, {
                                weaponSlot = object.weaponSlot
                            })
                        end

                        textDrawQueue[objectId] = {
                            text = template:template(debugValues),
                            x = screenSpaceX,
                            y = screenSpaceY,
                            color = color,
                            font = font
                        }
                    end
                end
            end
        end
    end
end

local generalBounds = {left = 0, top = 460, right = 640, bottom = 480}
local textColor = {1, 1, 1, 1}
local coordinatesFormat = "X: %.2f Y: %.2f Z: %.2f"
local anglesFormat = "Yaw: %.2f Pitch: %.2f Roll: %.2f"
local function OnFrame()
    if IsDebuggingCamera then
        local v1 = {x = camera.vX, y = camera.vY, z = camera.vZ}
        local v2 = {x = camera.v2X, y = camera.v2Y, z = camera.v2Z}
        local yaw, pitch, roll = blam.getVectorRotation(v1, v2)
        local coordinates = coordinatesFormat:format(camera.x, camera.y, camera.z)
        local angles = anglesFormat:format(yaw, pitch, roll)
        
        draw_text(coordinates, generalBounds.left + 16, generalBounds.top, generalBounds.left + 400,
                  generalBounds.bottom, "console", "left", table.unpack(textColor))
        draw_text(angles, generalBounds.left + 16, generalBounds.top - 16, generalBounds.left + 400,
                  generalBounds.bottom, "console", "left", table.unpack(textColor))
    end

    -- if not blam.getGameState().isLayerOpened then
    -- if not console_is_open() then
    if not getRenderedUIWidgetTagId() then
        for key, draw in pairs(textDrawQueue) do
            draw_text(draw.text, draw.x, draw.y, 640, 480, draw.font, "center", table.unpack(draw.color))
            if not draw.time then
                draw.time = os.clock()
            end
            if os.clock() - draw.time > 0.6 then
                textDrawQueue[key] = nil
            end
        end
    end
end

local onTickEvent
local onCameraEvent
local onFrameEvent

function PluginLoad()
    logger = balltze.logger.createLogger("Debug Tools")

    for command, data in pairs(commands) do
        local command = command:replace("debug_", "")
        balltze.command.registerCommand(command, command, data.description, data.help, true,
                                        data.minArgs or 0, data.maxArgs or 0, false, true,
                                        function(...)
            engine.core.consolePrint("Executing command: " .. command)
            --local success, message = pcall(data.func, table.unpack(...))
            --if not success then
            --    engine.core.consolePrint("Error executing command: " .. command)
            --    engine.core.consolePrint("Error message: " .. message)
            --end
            data.func(table.unpack(...))
            return true
        end)
    end
    balltze.command.loadSettings()

    -- Load Chimera compatibility
    for k, v in pairs(balltze.chimera) do
        if not k:includes "timer" and not k:includes "execute_script" and
            not k:includes "set_callback" then
            _G[k] = v
        end
    end

    onTickEvent = balltze.event.tick.subscribe(function(event)
        if event.time == "before" then
            debugEngine()
        end
    end)
    onCameraEvent = balltze.event.camera.subscribe(function(event)
        if event.time == "before" then
            local position = event.context.camera.position
            local orientation = event.context.camera.orientation
            -- Save camera state
            camera = {
                x = position.x,
                y = position.y,
                z = position.z,
                fov = event.context.camera.fov,
                vX = orientation[1].x,
                vY = orientation[1].y,
                vZ = orientation[1].z,
                v2X = orientation[2].x,
                v2Y = orientation[2].y,
                v2Z = orientation[2].z
            }
        end
    end)
    onFrameEvent = balltze.event.frame.subscribe(function (event)
        if event.time == "before" then
            OnFrame()
        end
    end)
end

function PluginUnload()
    logger:info("Debug Tools unloaded!")

    if onTickEvent then
        onTickEvent:remove()
    end
    if onCameraEvent then
        onCameraEvent:remove()
    end
    if onFrameEvent then
        onFrameEvent:remove()
    end
end
