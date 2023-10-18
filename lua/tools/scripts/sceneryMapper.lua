local tag = require "tools.modules.tag"
local inspect = require "inspect"
require "modules.luna"

local scenarioPath = arg[1]

local sceneryPalette = {}
local scenerys = {}
local sceneryProps = {"type", "position", "rotation"}

-- Get scenery palette
local sceneryPaletteCount = tag.count(scenarioPath, "scenery_palette")
for i = 0, sceneryPaletteCount - 1 do
    table.insert(sceneryPalette, tag.get(scenarioPath, "scenery_palette", i, "name"))
end

-- Get scenerys
local sceneryCount = tag.count(scenarioPath, "scenery")
for sceneryIndex = 0, sceneryCount - 1 do
    local scenery = {}
    for _, prop in ipairs(sceneryProps) do
        
        scenery[prop] = tag.get(scenarioPath, "scenery", sceneryIndex, prop) --[[@as string]]
        if prop == "type" then
            scenery.type = sceneryPalette[tonumber(scenery.type)]
        elseif prop == "position" then
            ---@type string
            local elements = scenery[prop]
            local values = elements:split(",")
            scenery[prop] = {x = values[1], y = values[2], z = values[3]}
        elseif prop == "rotation" then
            ---@type string
            local elements = scenery[prop]
            local values = elements:split(",")
            scenery[prop] = {y = values[1], p = values[2], r = values[3]}
        end
    end
    table.insert(scenerys, scenery)
end

print(inspect(scenerys))
