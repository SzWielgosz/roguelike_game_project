extends Node2D

var StartRoom = preload("res://Scenes/Rooms/14x14/room_left_right.tscn")

var new_preloaded_rooms = {
	"top": [
		preload("res://Scenes/Rooms/14x14/room_down.tscn"),
		preload("res://Scenes/Rooms/14x14/room_down_left.tscn"),
		preload("res://Scenes/Rooms/14x14/room_down_right.tscn"),
		preload("res://Scenes/Rooms/14x14/room_top_down.tscn")
	],
	"down": [
		preload("res://Scenes/Rooms/14x14/room_top.tscn"),
		preload("res://Scenes/Rooms/14x14/room_top_down.tscn"),
		preload("res://Scenes/Rooms/14x14/room_top_left.tscn"),
		preload("res://Scenes/Rooms/14x14/room_top_right.tscn")
	],
	"left": [
		preload("res://Scenes/Rooms/14x14/room_right.tscn"),
		preload("res://Scenes/Rooms/14x14/room_top_right.tscn"),
		preload("res://Scenes/Rooms/14x14/room_down_right.tscn"),
		preload("res://Scenes/Rooms/14x14/room_left_right.tscn")
	],
	"right": [
		preload("res://Scenes/Rooms/14x14/room_left.tscn"),
		preload("res://Scenes/Rooms/14x14/room_left_right.tscn"),
		preload("res://Scenes/Rooms/14x14/room_top_left.tscn"),
		preload("res://Scenes/Rooms/14x14/room_down_left.tscn")
	]
}
@onready var Map: TileMap = $"../TileMap"
@onready var Player = $"../Player"

var tile_size: int = 16
var rooms_to_generate: int = 8
var room_rects: Array[Rect2] = []
var room_positions: Array[Vector2] = []
var queue: Array = []
var spawn_directions = {"top": Vector2(0, -272), "down": Vector2(0, 272), "left": Vector2(-272, 0), "right": Vector2(272, 0)}
var start_room = null
var end_room = null



func does_overlap(new_room_rect: Rect2) -> bool:
	for existing_room_rect in room_rects:
		if existing_room_rect.intersects(new_room_rect):
			return true
	return false


func generate_rooms():
	while true:
		room_rects.clear()
		var remaining_rooms = rooms_to_generate
		var length: int = 16
		var start_position = Vector2i(0, 0)

		var starting_room = StartRoom.instantiate()
		var room_rect = Rect2(start_position, Vector2(length, length) * tile_size)
		room_rects.append(room_rect)
		starting_room.position = room_rect.get_center()
		start_position -= Vector2i(0, (length * tile_size) + 16)
		$"../Rooms".add_child(starting_room)
		queue.append(starting_room)

		while queue.is_empty() == false:
			var picked_room = queue.pop_front()
			var door_directions = picked_room.get_node("DoorCounter").get_doors()
			for key in door_directions.keys():
				if door_directions[key] == true:
					if remaining_rooms > 0:
						var room = new_preloaded_rooms[key].pick_random().instantiate()
						var generated_room_rect = Rect2(
							picked_room.position 
							- picked_room.get_node("Area2D").get_child(0).shape.extents 
							+ spawn_directions[key] - Vector2(length, length), 
							Vector2(length, length) * tile_size
						)
						if not does_overlap(generated_room_rect):
							$"../Rooms".add_child(room)
							room_rects.append(generated_room_rect)
							room.position = picked_room.position + spawn_directions[key]
							remaining_rooms -= 1
							queue.append(room)
						else:
							room.queue_free()

		var found_blind_doors = false
		for room in $"../Rooms".get_children():
			var door_directions = room.get_node("DoorCounter").get_doors()
			for key in door_directions.keys():
				if door_directions[key] == true:
					var generated_room_rect = Rect2(
						room.position 
						- room.get_node("Area2D").get_child(0).shape.extents 
						+ spawn_directions[key] - Vector2(length, length), 
						Vector2(length, length) * tile_size
					)
					if not does_overlap(generated_room_rect):
						print("Znaleziono drzwi prowadzące donikąd")
						found_blind_doors = true

		if found_blind_doors == true:
			print("Lista pokoi: ", $"../Rooms".get_children())

			for room in $"../Rooms".get_children():
				room.queue_free()

			await get_tree().process_frame
			found_blind_doors = false
			remaining_rooms = rooms_to_generate

			print("Lista pokoi po pętli: ", $"../Rooms".get_children())
		else:
			break

		for room in $"../Rooms".get_children():
			var current_tilemap = room.get_node("TileMap")
			var tilemap_layers_count = current_tilemap.get_layers_count()
			for i in range(tilemap_layers_count):
				for x in current_tilemap.get_used_cells(i):
					var cell_pos = x
					var atlas_coords = current_tilemap.get_cell_atlas_coords(i, cell_pos)
					var target_pos = (cell_pos * tile_size) + start_position
					Map.set_cell(i, target_pos / tile_size, 0, atlas_coords)
			current_tilemap.queue_free()



func find_start_room():
	var min_x = INF
	for room in $"../Rooms".get_children():
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x
	#start_room.get_child(0).set_room_type(RoomTypes.RoomType.START)


func find_end_room():
	var max_x = -INF
	for room in $"../Rooms".get_children():
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x
	#end_room.get_child(0).set_room_type(RoomTypes.RoomType.END)


func create_map():	
	generate_rooms()
	find_start_room()
	find_end_room()
	Player.global_position = start_room.global_position
	


#func _draw():
	#for room in room_rects:
		#draw_rect(room, Color(0, 1, 0), false)
