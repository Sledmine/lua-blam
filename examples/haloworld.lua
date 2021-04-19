-- Halo World (Chimera Script)
-- Example to print text on console

-- Set Chimera API version
clua_version = 2.056

function OnMapLoad()
    console_out("Halo World!")
end

set_callback("map load", "OnMapLoad")
