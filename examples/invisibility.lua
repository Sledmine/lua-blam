-- Example for Chimera Lua

local blam = require "blam"

clua_version = 2.042

function OnTick()
    local player = blam.biped(get_dynamic_player())
    if (player) then
        if (player.crouchHold) then
            player.invisible = true
        else
            player.invisible = false
        end
    end
end

set_callback("tick", "OnTick")
