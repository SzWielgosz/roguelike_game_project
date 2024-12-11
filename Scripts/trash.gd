extends Node2D

var Room = preload("res://Scenes/Room/room.tscn")
const RoomTypes = preload("res://Scripts/RoomTypes.gd")
var preloaded_rooms = [
	preload("res://Scenes/Rooms/14x14/Test_room.tscn"),
	preload("res://Scenes/Rooms/14x14/Room_down.tscn"),
	preload("res://Scenes/Rooms/14x14/Room_top.tscn"),
	preload("res://Scenes/Rooms/14x14/Room_left.tscn"),
	preload("res://Scenes/Rooms/14x14/Room_right.tscn"),
	preload("res://Scenes/Rooms/14x14/Room_left_right.tscn"),
	preload("res://Scenes/Rooms/14x14/Room_top_down.tscn"),
]
@onready var Map: TileMap = $"../TileMap"
@onready var Player = $"../Player"

var tile_size: int = 16
var number_of_rooms: int = 4
var start_room = null
var end_room = null
var room_rects: Array[Rect2] = []
var room_positions: Array[Vector2] = []
var room_tilemaps: Array[TileMap] = []
var directions: Array[String] = ["Left", "Right", "Up", "Down"]



func does_overlap(room: Rect2) -> bool:
	for existing_room in room_rects:
		if existing_room.intersects(room):
			return true
	return false


func generate_rooms():
	room_rects.clear()
	var length: int = 16 #rooms length
	var start_position = Vector2i(0, 0)
	
	while room_rects.size() < number_of_rooms:
		var picked_room = preloaded_rooms.pick_random().instantiate()
		var room_rect = Rect2(start_position, Vector2(length, length) * tile_size)
		
		if not does_overlap(room_rect):
			#picked_room.get_child(0).make_room(start_position, Vector2(length, length) * tile_size, RoomTypes.RoomType.REGULAR)
			room_rects.append(room_rect)
			room_positions.append(room_rect.get_center())
			picked_room.position = room_rect.get_center()
			$"../Rooms".add_child(picked_room)
			room_tilemaps.append(picked_room.get_node("TileMap"))
			
			#From here testing begins
			#var current_tilemap = picked_room.get_node("TileMap")
			#var tilemap_layers_count = current_tilemap.get_layers_count()
			#for i in range(tilemap_layers_count):
				#for x in current_tilemap.get_used_cells(i):
					#var cell_pos = x
					#var atlas_coords = current_tilemap.get_cell_atlas_coords(i, cell_pos)
					#var target_pos = (cell_pos * tile_size) + start_position
					#Map.set_cell(i, target_pos / tile_size, 0, atlas_coords)
			#current_tilemap.queue_free()
		
		
		start_position -= Vector2i(0, (length * tile_size) + 16)
		print("Start_position: ", start_position)



func create_map():	
	generate_rooms()
	find_start_room()
	find_end_room()
	
	# Create rooms
	#for room in $"../Rooms".get_children():
		#var size = (room.get_child(0).get_child(0).shape.extents / tile_size)
		#var top_left = (room.position / tile_size).floor()

	Player.position = start_room.position + (start_room.get_child(1).get_child(0).shape.extents)


		
		
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
		


func _draw():
	for room in room_rects:
		draw_rect(room, Color(0, 1, 0), false)
		
	#if path and path.get_point_count() > 1:
		#for p in path.get_point_ids():
			#for c in path.get_point_connections(p):
				#var pp = path.get_point_position(p)
				#var cp = path.get_point_position(c)
				#draw_line(pp, cp, Color(1, 1, 0), 2)
				#
	#var border = Rect2(Vector2(0, 0), Vector2(border_size * tile_size, border_size * tile_size))
	#draw_rect(border, Color(0, 1, 0), false)

