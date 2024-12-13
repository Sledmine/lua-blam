blam = require "blam"

-- Server
blam.rcon.event("Ping", function(message, playerIndex)
    return "Pong"
end)

-- Client
blam.rcon.dispatch("Ping").callback(function(response)
    console_out(response)
end)
