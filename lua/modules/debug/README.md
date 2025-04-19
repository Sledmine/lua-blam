# Debug Commands Documentation
This document provides a list of debug commands available in the game. Each command includes a
description, syntax, and example usage, you can use these commands in the console to manipulate
game objects, properties, and other aspects of the game environment.

## debug_spawn

**Description**  
Attempt to spawn any object in the map.

**Syntax**  
```c
void debug_spawn(string tagClass, string tagKeyword)
```
**Example**  
```lisp
debug_spawn weapon pistol
debug_spawn vehicle warthog
; You can also use the full tag path
debug_spawn vehicle vehicles\warthog\warthog
```

---

## debug_tags_list

**Description**  
List all tags of the specified class, optionally filtered by name.

**Syntax**  
```c
void debug_tags_list(string tagClass, string tagName)
```
**Example**  
```lisp
debug_tags_list vehicle
debug_tags_list vehicle warthog
debug_tags_list weapon pistol
debug_tags_list weapon weapons\pistol
```

---

## debug_player_animation

**Description**  
Play the specified animation index on the player biped.

**Syntax**  
```c
void debug_player_animation(int animIndex)
```

---

## debug_player_speed

**Description**  
Set the player movement speed.

**Syntax**  
```c
void debug_player_speed(float speed)
```

---

## debug_object_property

**Description**  
Get or set the specified object property.

**Syntax**  
```c
void debug_object_property(int objectIndex, string property, string value)
```

---

## debug_object_names

**Description**  
List all object names in the scenario, optionally filtered by name.

**Syntax**  
```c
void debug_object_names(string objectName)
```

---

## debug_open_widget

**Description**  
Open the specified widget.

**Syntax**  
```c
void debug_open_widget(string tagKeyword)
```
**Example**  
```lisp
debug_open_widget main_menu
debug_open_widget settings_menu
```

---

## debug_list_objects

**Description**  
List all objects in the map.

**Syntax**  
```c
void debug_list_objects()
```

---

## debug_tag_count

**Description**  
Print the number of tags in the map.

**Syntax**  
```c
void debug_tag_count()
```

---

## debug_delete_object

**Description**  
Delete the specified object.

**Syntax**  
```c
void debug_delete_object(int objectIndex)
```

---

## debug_network_objects

**Description**  
Print all network objects in the map or get information about the specified object.

**Syntax**  
```c
void debug_network_objects(int syncedIndex)
```

---

## debug_player_property

**Description**  
Get or set the specified player property.

**Syntax**  
```c
void debug_player_property(string property, string value)
```

---

## debug_teleport_to_object

**Description**  
Teleport the player to the specified object.

**Syntax**  
```c
void debug_teleport_to_object(int objectIndex)
```

---

## debug_game_objects

**Description**  
Enable or disable the debug game objects information on the screen.

**Syntax**  
```c
void debug_game_objects(bool enable)
```

---

## debug_assign_weapon

**Description**  
Assign the specified weapon to the specified object.

**Syntax**  
```c
void debug_assign_weapon(int objectIndex, int weaponObjectIndex)
```

---

## debug_enter_vehicle

**Description**  
Make the specified object enter the specified vehicle.

**Syntax**  
```c
void debug_enter_vehicle(int objectIndex, int vehicleObjectIndex)
```

---

## debug_exit_vehicle

**Description**  
Make specified object exit any vehicle it is in.

**Syntax**  
```c
void debug_exit_vehicle(int objectIndex)
```

---

## debug_add_weapon_to_inventory

**Description**  
Add the specified weapon to the player's inventory.

**Syntax**  
```c
void debug_add_weapon_to_inventory(int unitIndex, int weaponObjectIndex, int action)
```

---

## debug_player_add_weapon_to_inventory

**Description**  
Add the specified weapon to the player's inventory.

**Syntax**  
```c
void debug_player_add_weapon_to_inventory(int weaponObjectIndex, int action)
```

---

## debug_delete_all_weapons

**Description**  
Delete all weapons in the map.

**Syntax**  
```c
void debug_delete_all_weapons()
```

---

## debug_object_attach_to_marker

**Description**  
Attach the specified object to the specified marker.

**Syntax**  
```c
void debug_object_attach_to_marker(int objectIndex, string marker, int attachmentIndex, string attachmentMarker)
```

---

## debug_advanced_camera

**Description**  
Enable advanced camera mode.

**Syntax**  
```c
void debug_advanced_camera(bool enable)
```

---

## debug_game_data

**Description**  
Enable printing useful debug game data on the screen.

**Syntax**  
```c
void debug_game_data(bool enable)
```