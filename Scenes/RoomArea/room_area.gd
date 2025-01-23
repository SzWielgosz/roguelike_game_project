extends Area2D

var doors_opened: bool = true
var room_cleared: bool = false
var mobs_spawned: bool = false
var player_inside: bool = false
var mobs_left = []
@onready var timer = $"../CheckTimer"
var spawning: bool = false
signal spawn_mobs

func _ready():
	# Ustaw timer na określony czas (np. 1 sekunda)
	timer.wait_time = 1.0
	timer.start()

func _on_timer_timeout():
	# Sprawdź, czy pokój został wyczyszczony, tylko jeśli gracz jest w pokoju
	if player_inside and not spawning and mobs_left.is_empty() and not room_cleared:
		room_cleared = true
		if not doors_opened:  # Zapobiegaj wielokrotnemu otwieraniu
			open_all_doors()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true  # Gracz jest w pokoju
		if not room_cleared:
			if doors_opened:
				close_all_doors()
			spawn_mobs.emit()
			mobs_spawned = true
		else:
			if not doors_opened:
				open_all_doors()

	if body.is_in_group("mobs"):
		mobs_left.append(body)

func open_all_doors():
	for door in $"../Doors".get_children():
		door.open_door()
	doors_opened = true

func close_all_doors():
	for door in $"../Doors".get_children():
		door.close_door()
	doors_opened = false

func _on_body_exited(body):
	if body.is_in_group("mobs"):
		mobs_left.erase(body)
		# Sprawdź, czy wszystkie moby zostały usunięte
		if player_inside and mobs_left.is_empty() and not room_cleared:
			room_cleared = true
			if not doors_opened:  # Zapobiegaj wielokrotnemu otwieraniu
				open_all_doors()

func _on_spawn_timer_timeout():
	spawning = false
