# Global Variables

These are global variables that can be used by the script. Some of these variables may be changed multiple times by Chimera. Therefore, it is not recommended to modify these variables, as your modifications may be overwritten.

| Variable name      | Variable type | Description                                                                                                                                                                     |
| ------------------ | :-----------: | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| build              |    number     | This is the build of Chimera being used. Alpha builds are negative numbers, while public releases are positive numbers. (**WHAT!!!!!???**)                                      |
| full_build         |    number     | If the build of Chimera being used is an alpha build, then this is what the next public release build number will be. Otherwise, this is the build of Chimera being used.       |
| gametype           | string / nil  | This is the current gametype that is running. If no gametype is running, this will be set to nil, possible values are: ctf, slayer, oddball, king, race.                        |
| local_player_index | number / nil  | This is the index of the local player. This is a value between 0 and 15, this value does not match with player index in the server and is not instantly assigned after joining. |
| local_player_index | number / nil  | This is the index of the local player. This is a value between 0 and 15, this value does not match with player index in the server and is not instantly assigned after joining. |
| map                |    string     | This is the name of the current map.                                                                                                                                            |
| sandboxed          |    boolean    | Return whether or not the script is sandboxed. See Sandoboxed Scripts for more information.                                                                                     |
| script_name        |    string     | This is the name of the script. If the script is a global script, it will be defined as the filename of the script. Otherwise, it will be the name of the map.                  |
| script_type        |    string     | This is the name of the script. If the script is a global script, it will be defined as the filename of the script. Otherwise, it will be the name of the map.                  |
| server_type        |    string     | This is the server type, possible values are, none, local, dedicated.                                                                                                           |

# Game Functions

These functions do various miscellaneous things to the game.

| Function name      |                     Takes                      | Returns              | Description                                                                                                                                                                      |
| ------------------ | :--------------------------------------------: | -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| console_is_open    |                    nothing                     | boolean              | Return true if the player has the console open.                                                                                                                                  |
| console_out        |    Text string, r?, g?, b? / a?, r?, g?, b?    | nothing              | Output text to the console, optional text colors avoid sending console messages if console_is_open() is true to avoid annoying the player.                                       |
| delete_object      |         ObjectID / ObjectIndex number          | nothing              | Despawn an object given ObjectID. An error will occur if the object does not exist.                                                                                              |
| execute_script     |                 Script string                  | nothing              | Execute a custom Halo script. A script can be either a standalone Halo command or a Lisp-formatted Halo scripting block.                                                         |
| get_dynamic_player |               PlayerIndex number               | Address number / nil | Attempt to get the address to the player’s unit object, returning nil on failure. If no argument is given, the address to the local player’s unit object is returned, instead.   |
| get_global         |               GlobalName string                | Address number / nil | Get the value of a Halo scripting global. An error will occur if the global is not found.                                                                                        |
| get_object         |      ObjectID number / ObjectIndex number      | Address number / nil | Get the address to an object, returning nil on failure.                                                                                                                          |
| get_player         |      ObjectID number / ObjectIndex number      | Address number / nil | Attempt to get the address to the entry of a player in the player table, returning nil on failure. If no argument is given, the address to the local player is returned instead. |
| get_tag            | TagID number / TagClass string, TagPath string | Address number / nil | Attempt to get the address to the entry of a specified tag in the tag array, returning nil on failure.                                                                           |
| hud_message        |                  Text string                   | nothing              | Output text to the HUD. (**THIS NEEDS REVISION WE FOUND THAT IT CAN CAUSE SOME CRASHES AT LEAST IN OUR CHIMERA BUILD!**)                                                         |
| set_callback       | EventName string, CallbackFunctionName? string | nothing              | Set the callback for an event, overwriting the previous one if already set. A script can set at most one callback per event.                                                     |
| set_global         |   GlobalName string, Value number / boolean    | nothing              | Set the value of a Halo scripting global. An error will occur if the global does not exist. For boolean globals, if Value is a nonzero number, then it will be treated as true.  |
| set_timer          |   GlobalName string, Value number / boolean    |                      | Set the value of a Halo scripting global. An error will occur if the global does not exist. For boolean globals, if Value is a nonzero number, then it will be treated as true.  |


bool create_directory(directory)
bool remove_directory(directory)
table list_directory(directory)
bool directory_exists(directory)
bool write_file(file, content, append)
string|nil read_file(file)
bool delete_file(file)
bool file_exists(file)