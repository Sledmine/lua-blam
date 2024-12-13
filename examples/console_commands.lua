-- Commands (Chimera Script)
-- Example of how to use Chimera custom commands with blam

-- Import blam module
local blam = require "blam"

-- Set Chimera API version
clua_version = 2.056

function OnCommand(command)
    if (command == "jump") then
        local player = blam.biped(get_dynamic_player())
        if (player) then
            -- Apply velocity to the player to make it "jump", lua-blam powah!
            player.zVel = player.zVel + 0.2
        end
        console_out("Wahooo!") -- Mario is that you?
        --[[ Return false if we are intercepting the correct command to prevent the game from 
        sending the "Requested function blablabla" message]]
        return false
    end
end

set_callback("command", "OnCommand")
