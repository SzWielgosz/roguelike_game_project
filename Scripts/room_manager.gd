extends Node
class_name RoomManager

signal cleared_room
var entities
var cleared: bool = false

func _process(delta):
	entities = $"../Area2D".get_overlapping_bodies()
	if entities != []:
		for entity in entities:
			if entity.is_in_group("mobs"):
				pass
			else:
				cleared = true
				cleared_room.emit()
			
