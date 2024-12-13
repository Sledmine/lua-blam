local blam = require "blam"
local sqrt = math.sqrt
local abs = math.abs
local floor = math.floor
local ceil = math.ceil
local find = string.find
local pi = math.pi
local atan = math.atan
local tan = math.tan
local sin = math.sin
local cos = math.cos
local rad = math.rad

local engine = {}

--- Returns a new 3D vector
---@param x? number
---@param y? number
---@param z? number
---@return vector3D
local function new3dVector(x, y, z)
    return {x = x or 0, y = y or 0, z = z or 0}
end

local function new4x4Matrix()
    return {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
end

local function len(a)
    return sqrt(a.x * a.x + a.y * a.y + a.z * a.z)
end

local function multiplyVector4(out, a, b)
    local tv4 = {0, 0, 0, 0}
    tv4[1] = b[1] * a[1] + b[2] * a[5] + b[3] * a[9] + b[4] * a[13]
    tv4[2] = b[1] * a[2] + b[2] * a[6] + b[3] * a[10] + b[4] * a[14]
    tv4[3] = b[1] * a[3] + b[2] * a[7] + b[3] * a[11] + b[4] * a[15]
    tv4[4] = b[1] * a[4] + b[2] * a[8] + b[3] * a[12] + b[4] * a[16]

    for i = 1, 4 do
        out[i] = tv4[i]
    end

    return out
end

local function cross(a, b)
    return new3dVector(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
end

local function project(x, y, z, view, projection, viewport)
    local position = {x, y, z, 1}

    multiplyVector4(position, view, position)
    multiplyVector4(position, projection, position)

    if position[4] ~= 0 then
        position[1] = position[1] / position[4] * 0.5 + 0.5
        position[2] = position[2] / position[4] * 0.5 + 0.5
        position[3] = position[3] / position[4] * 0.5 + 0.5
    end

    position[1] = position[1] * viewport[3] + viewport[1]
    position[2] = position[2] * viewport[4] + viewport[2]
    return position[1], position[2], position[3]
end

local function scale(a, b)
    return new3dVector(a.x * b, a.y * b, a.z * b)
end

local function isZero(a)
    return a.x == 0 and a.y == 0 and a.z == 0
end

local function normalizeValue(a)
    if isZero(a) then
        return new3dVector()
    end
    return scale(a, (1 / len(a)))
end

local function fromPerspective(verticalFov, aspect, near, far)
    assert(aspect ~= 0)
    assert(near ~= far)

    local t = tan(rad(verticalFov) / 2)
    local out = new4x4Matrix()
    out[1] = 1 / (t * aspect)
    out[6] = 1 / t
    out[11] = -(far + near) / (far - near)
    out[12] = -1
    out[15] = -(2 * far * near) / (far - near)
    out[16] = 0

    return out
end

--- Returns a new 4x4 matrix
---@param out table
---@param eye vector3D
---@param look vector3D
---@param up vector3D
---@return table
local function lookAt(out, eye, look, up)
    eye.x = eye.x - look.x
    eye.y = eye.y - look.y
    eye.z = eye.z - look.z
    local zAxis = normalizeValue(eye)
    local xAxis = normalizeValue(cross(up, zAxis))
    local yAxis = cross(zAxis, xAxis)
    out[1] = xAxis.x
    out[2] = yAxis.x
    out[3] = zAxis.x
    out[4] = 0
    out[5] = xAxis.y
    out[6] = yAxis.y
    out[7] = zAxis.y
    out[8] = 0
    out[9] = xAxis.z
    out[10] = yAxis.z
    out[11] = zAxis.z
    out[12] = 0
    out[13] = 0
    out[14] = 0
    out[15] = 0
    out[16] = 1

    return out
end

--- Returns the vertical field of view
---@param fov number
---@return number
function engine.getVerticalFov(fov)
    local fov = fov * 180 / pi
    local verticalFov = atan(tan(fov * pi / 360) * (1 / blam.getScreenData().aspectRatio)) * 360 /
                            pi
    return verticalFov
end

--- Returns the distance between two 3D vectors
---@param v1 vector3D
---@param v2 vector3D
---@return number
function engine.getVectorsDistance(v1, v2)
    local dx = v1.x - v2.x
    local dy = v1.y - v2.y
    local dz = v1.z - v2.z
    return sqrt(dx * dx + dy * dy + dz * dz)
end

--- Returns projected 3D coordinates to screen space
---@param x number
---@param y number
---@param z number
---@param eyeX number
---@param eyeY number
---@param eyeZ number
---@param lookX number
---@param lookY number
---@param lookZ number
---@param verticalFov number
---@return number screenSpaceX, number screenSpaceY, number screenSpaceZ
function engine.worldCoordinatesToScreenSpace(x,
                                              y,
                                              z,
                                              eyeX,
                                              eyeY,
                                              eyeZ,
                                              lookX,
                                              lookY,
                                              lookZ,
                                              verticalFov)
    local viewXY = 0
    local viewWidth = 1 -- 1.12
    local viewHeight = 1 -- 1.12

    local view = new4x4Matrix()
    local eye = {x = eyeX, y = eyeY, z = eyeZ}
    local look = {x = lookX, y = lookY, z = lookZ}
    local up = {x = 0, y = 0, z = 1}

    local aspect = blam.getScreenData().aspectRatio
    local near = 0.000001
    local far = 1000000

    view = lookAt(view, eye, look, up)
    local projection = fromPerspective(verticalFov, aspect, near, far)
    local viewport = {viewXY, viewXY, viewWidth, viewHeight}

    --return project(x, y, z, view, projection, viewport)
    return engine.screenSpaceToCoordinates(project(x, y, z, view, projection, viewport))
end

--- Returns screen space converted coordinates from screen space
---@param screenSpaceX number
---@param screenSpaceY number
---@param screenSpaceZ number
---@return number x, number y, number z
function engine.screenSpaceToCoordinates(screenSpaceX, screenSpaceY, screenSpaceZ)
    -- Convert to screen space coordinates
    local x = -floor((50 - screenSpaceX * 100) * 6.4)
    local y = floor((50 - screenSpaceY * 100) * 4.9) + 200
    local z = screenSpaceZ
    return x, y, z
end

return engine
