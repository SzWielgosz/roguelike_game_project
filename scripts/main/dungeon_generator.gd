extends Node2D

var empty_room = preload("res://scenes/rooms/room_24x16/empty_room.tscn")
var door = preload("res://scenes/environment/props/door.tscn")
#preload("res://scenes/rooms/room_24x16/layouts/layout1.tscn"), 
var room_layouts = [preload("res://scenes/rooms/room_24x16/layouts/layout2.tscn")]
enum RoomType { REGULAR, TREASURE, START, END }
@onready var Map: TileMap = $"../TileMap"
@onready var Player = $"../Player"
@onready var minimap = $"../Minimap/MarginContainer/SubViewportCointainer/SubViewport/Node2D"
var tile_size: int = 16
var rooms_to_generate: int = 8
var room_dict: Dictionary = {}
var create_minimap_dict: Dictionary = {}
var queue: Array = []
var spawn_directions = {
	"top": Vector2(0, -272),
	"down": Vector2(0, 272),
	"left": Vector2(-400, 0),
	"right": Vector2(400, 0)
}
var spawn_door_directions = {
	"top": Vector2(0, -128),
	"down": Vector2(0, 128),
	"left": Vector2(-192, 0),
	"right": Vector2(192, 0)
}
var directions = {
	"top": 0,
	"right": 90,
	"down": 180,
	"left": 270
}
var length: int = 16
var width: int = 24
var height: int = 16
var start_room = null
var end_room = null


func does_overlap(new_room_rect: Rect2) -> bool:
	for existing_room_rect in room_dict.keys():
		if existing_room_rect.intersects(new_room_rect):
			return true
	return false
	

func get_overlaping_rect(new_room_rect: Rect2):
	for existing_room_rect in room_dict.keys():
		if existing_room_rect.intersects(new_room_rect):
			return existing_room_rect
	return null
	


func generate_rooms():
	var remaining_rooms = rooms_to_generate
	var start_position = Vector2(0, 0)
	var first_room = empty_room.instantiate()
	first_room.name = "Room_0"
	var room_rect = Rect2(start_position, Vector2(width, height) * tile_size)
	room_dict[room_rect] = first_room
	create_minimap_dict[room_rect] = first_room
	first_room.global_position = room_rect.position + (Vector2(width, height) * tile_size) / 2
	start_position -= Vector2(0, (width * tile_size) + 16)
	$"../Rooms".add_child(first_room)
	queue.append(first_room)
	remaining_rooms -= 1

	var room_index = 1

	while remaining_rooms > 0 and not queue.is_empty():
		var picked_room = queue.pop_front()
		var picked_room_position = picked_room.global_position

		var direction_options = directions.keys()
		direction_options.shuffle()

		for picked_direction in direction_options:
			if remaining_rooms <= 0:
				break

			var new_room = empty_room.instantiate()
			new_room.name = "Room_" + str(room_index)
			room_index += 1
			var new_room_position = picked_room_position + spawn_directions[picked_direction]

			var generated_room_rect = Rect2(
				new_room_position - picked_room.get_node("RoomArea").get_child(0).shape.extents - Vector2(width, height),
				Vector2(width, height) * tile_size
			)
			
			if not does_overlap(generated_room_rect):
				new_room.get_node("RoomArea").type = RoomType.REGULAR
				$"../Rooms".add_child(new_room)
				room_dict[generated_room_rect] = new_room
				create_minimap_dict[generated_room_rect] = new_room
				new_room.global_position = new_room_position
				queue.append(new_room)
				remaining_rooms -= 1
				break

# texturing rooms
	for room in $"../Rooms".get_children():
		var current_tilemap = room.get_node("TileMap")
		var tilemap_layers_count = current_tilemap.get_layers_count()

		for i in range(tilemap_layers_count):
			for x in current_tilemap.get_used_cells(i):
				var cell_pos = x
				var atlas_coords = current_tilemap.get_cell_atlas_coords(i, cell_pos)
				var target_pos = (cell_pos * tile_size) + Vector2i(room.global_position)
				Map.set_cell(i, target_pos / tile_size, 0, atlas_coords)

		current_tilemap.queue_free()
	print("End of generation")


func generate_minimap():
	for minimap_room_rect in room_dict.keys():
		for spawn_direction in spawn_directions.keys():
			var spawn_direction_position = spawn_directions[spawn_direction]
			var test_rect = Rect2(minimap_room_rect.position + spawn_direction_position, minimap_room_rect.size)
			if does_overlap(test_rect):
				var overlaping_rect = get_overlaping_rect(test_rect)
				room_dict[minimap_room_rect].neighbours[spawn_direction] = create_minimap_dict[overlaping_rect]
	minimap.create_minimap(room_dict)

func add_room_layouts():
	for room in $"../Rooms".get_children():
		if room.get_node("RoomArea").type == RoomType.REGULAR:
			var room_layout = room_layouts.pick_random().instantiate()
			
			var original_nav = room_layout.get_node("NavigationRegion2D")
			if original_nav:
				var new_nav = original_nav.duplicate() 
				room_layout.remove_child(original_nav)
				room_layout.add_child(new_nav)
				new_nav.owner = room_layout
			room.get_node("RoomLayout").add_child(room_layout)


func connect_rooms():
	var created_rooms = $"../Rooms".get_children()
	for room in created_rooms:
		for direction in directions.keys():
			var check_rect = Rect2(room.global_position, Vector2(width, height))
			check_rect.position += spawn_directions[direction]
			if does_overlap(check_rect):
				var connect_door = door.instantiate()
				room.get_node("Doors").add_child(connect_door)
				connect_door.global_position = room.global_position + spawn_door_directions[direction]
				connect_door.rotation_degrees = directions[direction]

				var tilemap_position = Map.local_to_map(room.global_position + spawn_door_directions[direction])

				var offsets = {
					"top": [Vector2i(-1, 0), Vector2i(-1, -1), Vector2i(0, -1)],
					"down": [Vector2i(-1, 0), Vector2i(-1, -1), Vector2i(0, -1)],
					"left": [Vector2i(0, -1), Vector2i(-1, -1), Vector2i(-1, 0)],
					"right": [Vector2i(0, -1), Vector2i(-1, -1), Vector2i(-1, 0)]
				}


				Map.set_cell(0, tilemap_position, 0, Vector2i(5, 3))
				Map.erase_cell(1, tilemap_position)
				for offset in offsets.get(direction, []): 
					Map.set_cell(0, tilemap_position + offset, 0, Vector2i(5, 3))
					Map.erase_cell(1, tilemap_position + offset)


func find_start_room():
	var min_x = INF
	for room in $"../Rooms".get_children():
		if room.global_position.x < min_x:
			start_room = room
			min_x = room.global_position.x
	start_room.get_node("RoomArea").type = RoomType.START


func find_end_room():
	var max_x = -INF
	for room in $"../Rooms".get_children():
		if room.global_position.x > max_x:
			end_room = room
			max_x = room.global_position.x
	end_room.get_node("RoomArea").type = RoomType.END


func spawn_player():
	Player.global_position = start_room.global_position
	return


func create_dungeon():	
	generate_rooms()
	connect_rooms()
	find_start_room()
	find_end_room()
	generate_minimap()
	add_room_layouts()
	spawn_player()
	

#func _draw():
	#for room_rect in room_dict.values():
		#draw_rect(room_rect, Color(0, 1, 0), false)
