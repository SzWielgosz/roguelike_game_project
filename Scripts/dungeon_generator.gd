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
	preload("res://Scenes/Rooms/14x14/Room_top_left.tscn"),
	preload("res://Scenes/Rooms/14x14/Room_top_right.tscn"),
	preload("res://Scenes/Rooms/14x14/Room_down_left.tscn"),
	preload("res://Scenes/Rooms/14x14/Room_down_right.tscn"),
]
@onready var Map: TileMap = $"../TileMap"
@onready var Player = $"../Player"

var tile_size: int = 16
var rooms_to_generate: int = 8
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
	var length: int = 16  # room size in tiles
	var start_position = Vector2i(0, 0)

	while rooms_to_generate != 0:
		var picked_room = preloaded_rooms.pick_random().instantiate()
		print(preloaded_rooms.size())
		
		var doors = picked_room.get_node("Door_counter").get_doors()
		
		var room_rect = Rect2(start_position, Vector2(length, length) * tile_size)
		
		# Sprawdź, czy pokój nie zachodzi na inne i czy drzwi pasują
		if not does_overlap(room_rect):
			room_rects.append(room_rect)
			room_positions.append(room_rect.get_center())
			picked_room.position = room_rect.get_center()
			$"../Rooms".add_child(picked_room)
			room_tilemaps.append(picked_room.get_node("TileMap"))
		
		# Aktualizuj pozycję do następnego pokoju
		start_position -= Vector2i(0, (length * tile_size) + 16)
		#print("Start_position: ", start_position)

func create_map():	
	generate_rooms()


func _draw():
	for room in room_rects:
		draw_rect(room, Color(0, 1, 0), false)
