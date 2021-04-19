-- Halo World (Chimera Script)
-- Example to text print if the blam module was loaded successfully

-- Import blam module
local blam = require "blam"

-- Set Chimera API version
clua_version = 2.056

function OnMapLoad()
    if (blam) then
        console_out("Halo World")
    end
end

set_callback("map load", "OnMapLoad")
