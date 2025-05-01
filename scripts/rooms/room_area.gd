extends Area2D
class_name RoomArea

enum RoomType { REGULAR, TREASURE, START, END, SHOP }
var room_visited: bool = false
var doors_opened: bool = true
var room_cleared: bool = false
var mobs_spawned: bool = false
var player_inside: bool = false
var mobs_left = []
@onready var timer = Timer.new()
@export var type: RoomType
var spawning: bool = false
signal spawn_mobs


func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.1
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	if type == RoomType.START:
		room_cleared = true


func _on_timer_timeout():
	if player_inside and not spawning and mobs_left.is_empty() and not room_cleared:
		room_cleared = true
		if not doors_opened:
			GameStats.player_clearing_room = false
			open_all_doors()


func _on_body_entered(body):
	if body.is_in_group("player"):
		$"../Icon".visible = true
		if type == RoomType.REGULAR:
			if not room_visited:
				room_visited = true
			player_inside = true
			if not room_cleared:
				if doors_opened:
					close_all_doors()
				if not mobs_spawned:
					GameStats.player_clearing_room = true
					spawn_mobs.emit()
					mobs_spawned = true
			else:
				if not doors_opened:
					GameStats.player_clearing_room = false
					open_all_doors()

	if body.is_in_group("mobs"):
		mobs_left.append(body)


func open_all_doors():
	for door in get_parent().get_node("Doors").get_children():
		door.open_door()
	doors_opened = true


func close_all_doors():
	for door in get_parent().get_node("Doors").get_children():
		door.close_door()
	doors_opened = false


func _on_body_exited(body):
	if body.is_in_group("mobs"):
		mobs_left.erase(body)
		if player_inside and mobs_left.is_empty() and not room_cleared:
			room_cleared = true
			if not doors_opened:
				GameStats.player_clearing_room = false
				open_all_doors()


func _on_spawn_timer_timeout():
	spawning = false
