
-- Blam script example for Chimera - 572/582 Lua scripting.

local blam = require("luablam") -- Imported from Lua folder.

clua_version = 2.042 -- Set API version.

set_callback("command", "onCommand") -- Register callback, run function "onCommand" when triggered.

function onCommand(command)
    if (command == "invi") then -- If we wan to get or unget invisible then...

        local playerAddress = get_dynamic_player() -- Get current player memory address.

        if (playerAddress ~= nil) then -- There are no errors getting player address then...

            -- Get biped data of the specified object address (giving current player address).
            local playerBiped = blam.biped(playerAddress)

            if (playerBiped ~= nil) then -- If there are no errors getting player biped data then...
                
                -- Save player invisible property into "playerIsInvisible" variable
                playerIsInvisible = playerBiped.invisible

                -- Refresh biped data info giving table/object with invisible property with "not" operator to invert value
                blam.biped(playerAddress, { invisible = not(playerIsInvisible) })

            end
        end

        return false
    end
end