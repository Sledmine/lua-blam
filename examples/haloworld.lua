-- Halo World (Chimera Script)
-- Example to text print if the blam module was loaded successfully

local blam = require "blam"

-- Set Chimera API version
clua_version = 2.056

function OnCommand(command)
    if (blam) then
        console_out("Halo World")
    end
end

set_callback("map load", "OnMapLoad")
