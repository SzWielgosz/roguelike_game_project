extends Node2D

var create_minimap_dict: Dictionary = {}
@onready var minimap_rooms = $Rooms
@onready var player_icon = $PlayerIcon
var visited_rooms = {}
var queue = []
var minimap_icons = {}

func _ready():
	Events.room_entered.connect(_on_room_entered)

#BFS algorithm
func create_minimap(create_dict):
	var minimap_rooms_children = minimap_rooms.get_children()
	print("Minimap children przed: ", minimap_rooms_children)
	if minimap_rooms_children:
		for minimap_room in minimap_rooms_children:
			minimap_rooms.remove_child(minimap_room)
			minimap_room.queue_free()
	print("Minimap children po: ", minimap_rooms_children)
	create_minimap_dict = create_dict
	if create_minimap_dict.is_empty():
		return

	var start_room_key = create_minimap_dict.values()[0]
	visited_rooms[start_room_key] = Vector2(0, 0)
	queue.append(start_room_key)
	player_icon.global_position = Vector2(0,0)

	while queue.size() > 0:
		var current_room = queue.pop_front()
		var current_position = visited_rooms[current_room]

		var original_icon = current_room.get_node("Icon")
		var room_icon = original_icon.duplicate()
		if current_room.get_node("RoomArea").room_cleared:
			room_icon.visible = true
			room_icon.get_node("Entered").visible = true
			room_icon.get_node("Hidden").visible = false
		minimap_rooms.add_child(room_icon)
		room_icon.global_position = current_position

		minimap_icons[current_room] = room_icon  

		for direction in ["top", "down", "left", "right"]:
			var neighbour = current_room.neighbours.get(direction)
			if neighbour and not visited_rooms.has(neighbour):
				var gap = original_icon.gaps[direction]
				var offset = get_offset(direction, gap)
				visited_rooms[neighbour] = current_position + offset
				queue.append(neighbour)

func get_offset(direction: String, gap: int) -> Vector2:
	match direction:
		"top":
			return Vector2(0, -gap)
		"down":
			return Vector2(0, gap)
		"left":
			return Vector2(-gap, 0)
		"right":
			return Vector2(gap, 0)
	return Vector2.ZERO


func _on_room_entered(room):
	print("Entered:", room)
	
	if visited_rooms.has(room):
		player_icon.global_position = visited_rooms[room]

	if minimap_icons.has(room):
		minimap_icons[room].visible = true
		minimap_icons[room].get_node("Entered").visible = true
		minimap_icons[room].get_node("Hidden").visible = false
		
	for direction in ["top", "down", "left", "right"]:
		var neighbour = room.neighbours.get(direction)
		if neighbour and minimap_icons.has(neighbour):
			minimap_icons[neighbour].visible = true
