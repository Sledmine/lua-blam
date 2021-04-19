-- Invisiblity (Chimera Script)
-- Example of how to get and modifY data from biped objects

local blam = require "blam"

-- Chimera API version
clua_version = 2.056

function OnTick()
    local playerBiped = blam.biped(get_dynamic_player())
    if (playerBiped) then
        if (playerBiped.crouchHold) then
            playerBiped.invisible = true
        else
            playerBiped.invisible = false
        end
    end
end

set_callback("tick", "OnTick")
