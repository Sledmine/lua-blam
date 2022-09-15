
# Chimera - Lua
Lua for Chimera is a feature that exposes different game functions to a scripting enviroment where
different scripts can use Lua code to perform different actions in the game, such as creating an
innovative game type, adding new game features, functionality and create awesome mods with all we
mentioned before.

# Chimera - Lua API
This is an alternative documentation for the Chimera Lua API for `chimera-581`, updated to the
latest API available on `chimera-1.0.0-r912`, some parts are missing so if you don't find what you
need here, take a look at the [original documentation.](../archive/CHIMERA_LUA_DOCS_2_X_X.pdf)
- [Chimera - Lua](#chimera---lua)
- [Chimera - Lua API](#chimera---lua-api)
- [Global Variables](#global-variables)
- [Game functions](#game-functions)
  - [`console_is_open`](#console_is_open)
  - [`console_out`](#console_out)
  - [`execute_script`](#execute_script)
  - [`get_global`](#get_global)
  - [`set_global`](#set_global)
  - [`get_tag`](#get_tag)
  - [`set_callback`](#set_callback)
  - [`set_timer`](#set_timer)
  - [`stop_timer`](#stop_timer)
  - [`tick_rate`](#tick_rate)
  - [`ticks`](#ticks)
- [Object functions](#object-functions)
  - [`spawn_object`](#spawn_object)
  - [`delete_object`](#delete_object)
  - [`get_object`](#get_object)
  - [`get_dynamic_player`](#get_dynamic_player)
- [Interface functions](#interface-functions)
  - [`hud_message`](#hud_message)
  - [`load_ui_widget`](#load_ui_widget)
- [Memory functions](#memory-functions)
- [Data functions](#data-functions)
  - [`create_directory`](#create_directory)
  - [`remove_directory`](#remove_directory)
  - [`directory_exists`](#directory_exists)
  - [`list_directory`](#list_directory)
  - [`write_file`](#write_file)
  - [`read_file`](#read_file)
  - [`delete_file`](#delete_file)
  - [`file_exists`](#file_exists)

# Global Variables


These are global variables that can be used by the script. Some of these variables may be changed multiple times by Chimera. Therefore, it is not recommended to modify these variables, as your modifications may be overwritten.

| Variable name      | Variable type    | Description                                                                                                                                                                     |
| ------------------ | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| build              | `number`         | This is the build of Chimera being used. Alpha builds are negative numbers, while public releases are positive numbers. (**WHAT!!!!!???**)                                      |
| full_build         | `number`         | If the build of Chimera being used is an alpha build, then this is what the next public release build number will be. Otherwise, this is the build of Chimera being used.       |
| gametype           | `string` / `nil` | This is the current gametype that is running. If no gametype is running, this will be set to nil, possible values are: ctf, slayer, oddball, king, race.                        |
| local_player_index | `number` / `nil` | This is the index of the local player. This is a value between 0 and 15, this value does not match with player index in the server and is not instantly assigned after joining. |
| map                | `string`         | This is the name of the current map.                                                                                                                                            |
| map_is_protected   | `boolean`        | Return if the map has protected tags data                                                                                                                                       |
| sandboxed          | `boolean`        | Return whether or not the script is sandboxed. See Sandoboxed Scripts for more information.                                                                                     |
| script_name        | `string`         | This is the name of the script. If the script is a global script, it will be defined as the filename of the script. Otherwise, it will be the name of the map.                  |
| script_type        | `string`         | This is the name of the script. If the script is a global script, it will be defined as the filename of the script. Otherwise, it will be the name of the map.                  |
| server_type        | `string`         | This is the server type, possible values are, none, local, dedicated.                                                                                                           |

# Game functions

These functions can get, set or perform different operations that interact with the game state.

## `console_is_open`
Return true if the player has the console open, always returns true on SAPP.

**Returns:** `boolean` IsOpen

Example:
```lua
if (console_is_open()) then
    -- Do something
end
```
## `console_out`
Output text to the console, optional text colors in decimal format, avoid sending console messages
if console_is_open() is true to avoid annoying the player.

**Takes (a):** `string` text

**Takes (b):** `string` text, `number` red, `number` green, `number` blue

**Takes (c):** `string` text, `number` alpha, `number` red, `number` green, `number` blue

Example:
```lua
console_out("Halo World!")
console_out("Halo World, with RGB color!", 0.5, 1, 0.3)
console_out("Halo World, with ARGB color!", 1, 0.5, 1, 0.3)
```

## `execute_script`
Execute a custom Halo script. A script can be either a standalone Halo command or a Lisp-formatted
Halo scripting block.

**Takes:** `string` script

Example:
```lua
execute_script("sv_players")
```

## `get_global`
Get the value of a Halo scripting global. An error will occur if the global is not found.

**Takes:** string GlobalName

**Returns (a):** number Value

**Returns (b):** boolean Value

Example:
```lua
local current_firefight_wave = get_global("wave")
```

## `set_global`
Set the value of a Halo scripting global. An error will occur if the global does not exist.

**Note:** For `boolean` globals, if Value is a nonzero number, then it will be treated as `true`.

**Takes (a):** `string` globalName, `number` value

**Takes (b):** `string` globalName, `boolean` value

## `get_tag`
Attempt to get the address to the entry of a specified tag in the tag array, returning nil on
failure.

**Takes (a):** `number` TagID

**Takes (b):** `string` TagClass, `string` TagPath

**Returns:** optional `number` Address

Example:
```lua
local pistol_tag_address = get_tag("weapon","weapons\\pistol\\pistol")
```

## `set_callback`
Set the callback for an event, overwriting the previous one if already set. A script can set at most
one callback per event.

Priorities are as follows:
  - **before:** The callback is executed before the default callbacks are executed.
  - **default:** This is the default priority if NewFunctionPriority is not given.
  - **after:** The callback is executed after the default callbacks are executed.
  - **final:** The callback is executed latest and any returned values are disregarded from this
  - callback.

**Takes:** `string` EventName, `optional` string CallbackFunctionName, optional `string`CallbackPriority

**Note:** If multiple scripts have the same callback with the same priority, the callbacks will be
executed in script load order.

**Note:** Use the final priority for monitoring any changes made to the event, taking prior changes
from scripts executed in the before, default, and after callbacks into account.

Example:
```lua
function OnTick()
  -- Do something every tick event
end 
set_callback("tick", "OnTick")
```

Example:
```lua
set_global("wave", 10)
set_global("spawn_floods", true)
```

## `set_timer`
Register a timer and return an ID that can be used with the stop_timer function.
The function will be executed repeatedly with the specified argument(s) until it either returns
false or is deleted with stop_timer.

The argument(s) specified can be of type string, number, boolean, or nil.

**Takes:** `number` IntervalMilliseconds, `string` FunctionName, optional `ambiguous` Argument1, …

**Returns:** `number` TimerID

Example:
```lua
function message_every_second(message)
    console_out(message)
end 

set_timer(1000, "message_every_second", "Halo World!")
```

## `stop_timer`
Delete a timer by its ID. An error will occur if the timer ID does not exist.

**Takes:** `number` TimerID

Example:
```lua
stop_timer(5)
```

## `tick_rate`
Get or set the tick rate. The tick rate cannot be set lower than 0.01.

**Takes:** optional `number` NewTickRate

**Returns:** `number` TickRate

Example:
```lua
-- Set tick rate
tick_rate(60)

-- Get tick rate
console_out(tick_rate())
```

## `ticks`
Get the number of ticks that have passed. This value may be a decimal value to indicate the amount
of time that has passed between ticks.

**Returns:** `number` Ticks

Example:
```lua
console_out("Ticks that have passed " .. tostring(ticks()))
```

---

# Object functions
Functions that can alter the objects game state, spawn new objects in game, erase existing ones,
etc.


## `spawn_object`
Attempt to spawn an object. An error will occur if the tag does not exist. This function may be
intercepted by the spawn event by a Lua script.

**Takes (a):** `number` tagId, `number` x, `number` y, `number` z

**Takes (b):** `string` tagClass, `string` tagPath, `number` x, `number` y, `number` z

**Returns:** `number` objectId

Example:
```lua
local object_id = spawn_object("weapon","weapons\\pistol\\pistol", 0, 10, -4.5)
```

## `delete_object`
Despawn an object given objectId. An error will occur if the object does not exist.

**Takes:** `number` objectId

Example:
```lua
delete_object(31456126446)
```

## `get_object`
Get the address to an object, returning nil on failure.

**Takes:** `number` objectId

**Returns:** `number` address

Example:
```lua
local object_address = get_object(3456789065)
```

## `get_dynamic_player`
Attempt to get the address to the player’s unit object, returning nil on failure. If no argument is
given, the address to the local player’s unit object is returned, instead.

**Takes:** optional `number` PlayerIndex

**Returns:** optional `number` Address

Example:
```lua
local current_player_object_address = get_dynamic_player()

local player_4_object_address = get_dynamic_player(4)
```

---

# Interface functions
Functions that allow you to give some kind of interaction with the game interface.

## `hud_message`
Output text to the HUD.

**WARNING!!!!** We found this function can cause random crashes, at least on our chimera lua build.

**Takes:** `string` Output

Example:
```lua
hud_message("Halo World from HUD!")
```

## `load_ui_widget`
Attempt to load and open a ui widget in the game given tag path.

**Takes:** `string` TagPath

**Returns:** `boolean` Success

Example:
```lua
local success = load_ui_widget("ui\\shell\\multiplayer_game\\pause_game\\1p_pause_game")
if (success) then
    console_out("Widget was loaded correctly!")
else
    console_out("An error ocurred at trying to load widget!")
end

```

# Memory functions
These functions read/write Halo’s virtual memory. If the script is sandboxed, then write functions
will only work for addresses between 0x40000000 and 0x41B00000.

**Note:** Attempting to write to read-only memory and reading/writing invalid memory may result in a
segmentation fault. This will invariably result in an exception error.

**// TODO**


# Data functions

These functions perform operations that only can access and write data related to the current
script, these functions will operate only on the "chimera/lua/data" in a folder with the same name
of the script.

## `create_directory`
Attempt create a directory with the given path. An error will occur if the directory can not be
created.

**Takes:** `string` DirectoryName, `directoryName` X, `number` Y, `number` Z

**Returns:** `boolean` Result

Example:
```lua
local result = create_directory("logs")
if (result) then
    console_out("Logs folder has been created.")
else
    console_out("A problem occurred at creating logs folder.")
end
```

## `remove_directory`
Attemtp to remove a directory given path for it.

**Takes:** `string` path

**Returns:** `boolean` result

Example:
```lua
local removed = remove_directory("logs")
if result then
    console_out("Logs folder has been removed.")
else
    console_out("A problem occurred at removing logs folder.")
end
```

## `directory_exists`
Attempt to find if a directory exists.

Takes: `string` path

Returns: `boolean` result

Example:
```lua
local exists = directory_exists("my_folder")
if exists then
   console_out("It exists")
end
```

## `list_directory`
Attempt to list files and folders given a directory path.

**Takes:** `string` path

**Returns:** `boolean` result

Example:
```lua
local list = list_directory("configs")
for index, element in pairs(list) do
  console_out(element)
end
```

## `write_file`
Write content to a text file given file path.

**Takes:** `string` path, `string` content, `boolean` append

**Returns:** `boolean` result

Example:
```lua
local wrote = write_file("settings.txt", "some settings stuff")
if wrote then
  console_out("File was written successfully")
end
```

## `read_file`
Read the contents from a file given file path.

Takes: `string` path

Returns: `string` content | `nil`

Example:
```lua
local content = read_file("settings.txt")
if content then
   console_out(content)
else
    console_out("An error ocurred at reading settings.txt")
end
```
## `delete_file`
Delete a file given file path.

**Takes:** `string` path

**Returns:** `boolean` result

Example:
```lua
local deleted = delete_file("settings.txt")
if deleted then
   console_out("Successfully deleted settings.txt")
else
   console_out("An error ocurred at deleting settings.txt")
end
```

## `file_exists`
Return if a file exists given file path.

**Takes:** `string` path

**Returns:** `boolean` result

Example:
```lua
local exists = file_exists("settings.txt")
if exists then
   console_out("File settings.txt exists!")
else
   console_out("settings.txt does not exists.")
end
```
