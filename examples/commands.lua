-- Example for Chimera Lua
-- Commands
-- Example of how to use Chimera custom commands with blam
local blam = require "blam"

clua_version = 2.042

function OnCommand(command)
    -- Wohooo!
    if (command == "mario") then
        local player = blam.biped(get_dynamic_player())
        if (player) then
            -- Apply velocity to the player, lua blam powah!
            player.zVel = player.zVel + 0.2
        end
        --[[ Return false if we are intercepting the correct command to prevent the game from 
        sending the "Requested function blabla" message]]
        return false
    end
end

set_callback("command", "OnCommand")
