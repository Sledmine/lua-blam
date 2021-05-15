------------------------------------------------------------------------------
-- Chimera API Bindings for SAPP
-- Sledmine
-- SAPP bindings for Chimera Lua functions, also EmmyLua helper
------------------------------------------------------------------------------
if (variableThatObviouslyDoesNotExist) then
    -- All the functions at the top of the module are for EmmyLua autocompletion purposes!
    -- They do not have a real implementation and are not supossed to be imported
    --- Attempt to spawn an object given tag id and coordinates or tag type and class plus coordinates
    ---@param tagId number Optional tag id of the object to spawn
    ---@param tagType string Type of the tag to spawn
    ---@param tagPath string Path of object to spawn
    ---@param x number
    ---@param y number
    ---@param z number
    function spawn_object(tagType, tagPath, x, y, z)
    end

    --- Get object address from a specific player given playerIndex
    ---@param playerIndex number
    ---@return number Player object memory address
    function get_dynamic_player(playerIndex)
    end
end
if (api_version) then
    -- Provide global server type variable on SAPP
    server_type = "sapp"

    local split = function(s, sep)
        if (sep == nil or sep == "") then
            return 1
        end
        local position, array = 0, {}
        for st, sp in function()
            return string.find(s, sep, position, true)
        end do
            table.insert(array, string.sub(s, position, st - 1))
            position = sp + 1
        end
        table.insert(array, string.sub(s, position))
        return array
    end

    --- Function wrapper for file writing from Chimera to SAPP
    ---@param path string Path to the file to write
    ---@param content string Content to write into the file
    ---@return boolean | nil, string True if successful otherwise nil, error
    function write_file(path, content)
        local file, error = io.open(path, "w")
        if (not file) then
            return nil, error
        end
        local success, err = file:write(content)
        file:close()
        if (not success) then
            os.remove(path)
            return nil, err
        else
            return true
        end
    end

    --- Function wrapper for file reading from Chimera to SAPP
    ---@param path string Path to the file to read
    ---@return string | nil, string Content of the file otherwise nil, error
    function read_file(path)
        local file, error = io.open(path, "r")
        if (not file) then
            return nil, error
        end
        local content, error = file:read("*a")
        if (content == nil) then
            return nil, error
        end
        file:close()
        return content
    end

    -- TODO PENDING FUNCTION!!
    function directory_exists(dir)
        return true
    end

    --- Function wrapper for directory listing from Chimera to SAPP
    ---@param dir string
    function list_directory(dir)
        -- TODO This needs a way to separate folders from files
        if (dir) then
            local command = "dir " .. dir .. " /B"
            local pipe = io.popen(command, "r")
            local output = pipe:read("*a")
            if (output) then
                local items = split(output, "\n")
                for index, item in pairs(items) do
                    if (item and item == "") then
                        items[index] = nil
                    end
                end
                return items
            end
        end
        return nil
    end

    --- Return the memory address of a tag given tagId or tagClass and tagPath
    ---@param tagIdOrTagType string | number
    ---@param tagPath string
    ---@return number
    function get_tag(tagIdOrTagType, tagPath)
        if (not tagPath) then
            return lookup_tag(tagIdOrTagType)
        else
            return lookup_tag(tagIdOrTagType, tagPath)
        end
    end

    --- Execute a game command or script block
    ---@param command string
    function execute_script(command)
        return execute_command(command)
    end

    --- Return the address of the object memory given object id
    ---@param objectId number
    ---@return number
    function get_object(objectId)
        if (objectId) then
            local object_memory = get_object_memory(objectId)
            if (object_memory ~= 0) then
                return object_memory
            end
        end
        return nil
    end

    --- Delete an object given object id
    ---@param objectId number
    function delete_object(objectId)
        destroy_object(objectId)
    end

    --- Print text into console
    ---@param message string
    ---@param red number
    ---@param green number
    ---@param blue number
    function console_out(message, red, green, blue)
        -- TODO Add color printing to this function
        cprint(message)
    end

    --- Get if the game console is opened \
    --- Always returns true on SAPP.
    ---@return boolean
    function console_is_open()
        return true
    end

    --- Get the value of a Halo scripting global\
    ---An error will occur if the global is not found.
    ---@param name string Name of the global variable to get from hsc
    ---@return boolean | number
    function get_global(name)
        error("SAPP can't retrieve global variables as Chimera does.. yet!")
    end

    --- Print messages to the player HUD\
    ---Server messages will be printed if executed from SAPP.
    ---@param message string
    function hud_message(message)
        for playerIndex = 1, 16 do
            if (player_present(playerIndex)) then
                rprint(playerIndex, message)
            end
        end
    end

    print("Compatibility with Chimera Lua API has been loaded!")
end
