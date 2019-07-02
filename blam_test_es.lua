local blam = require("luablam")

clua_version = 2.042 -- Definir el API para el script.

set_callback("command", "OnCommand")

function OnCommand(Command)
    if (Command == "invis") then -- Si el comando que se introdujo fue "invis" entonces...
        
        local memoriaBiped = get_dynamic_player() -- Guardar la dirección de memoria del jugador

        if (memoriaBiped ~= nil) then -- Si la dirección de memoria se obtuvo correctamente entonces...
            console_out("El valor del biped en memoria es: "..memoriaBiped) -- Imprimir la dirección del jugador

             -- Crear objeto tipo biped con la memoria del jugador.
            local bipedJugador = blam.biped(memoriaBiped) -- Obtener datos.

            -- Imprimir en consola si el jugador es invisible antes del comando
            console_out("Antes del comando, invisible = "..tostring(bipedJugador.invisible))

            -- Definir el estado "invisible" del biped del jugador al contrario
            blam.biped(memoriaBiped, {invisible = not(bipedJugador.invisible)}) -- Escribir datos.

            -- Actualizar el objeto biped creado de la memoria del jugador
            bipedJugador = blam.biped(memoriaBiped) -- Refrescar datos.

            -- Imprimir el nuevo estado "invisible" del jugador.
            console_out("Luego del comando, invisible = "..tostring(bipedJugador.invisible))

        else
            console_out("Error al obtener la memoria del jugador local.")
        end
        return false
    end
end