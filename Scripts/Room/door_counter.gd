extends Node2D
class_name DoorCounter

func get_doors():
	var can_spawn_room = {
		"top": false, 
		"down": false,
		"left": false,
		"right": false
	}
	
	var doors_container = get_parent().get_node("Doors")
	for door in doors_container.get_children():
		var door_name = door.name
		match door_name:
			"DoorTop": 
				can_spawn_room["top"] = true
			"DoorDown":
				can_spawn_room["down"] = true
			"DoorLeft":
				can_spawn_room["left"] = true
			"DoorRight":
				can_spawn_room["right"] = true


	return can_spawn_room
