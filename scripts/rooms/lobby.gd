extends Node2D
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var alchemist: Node2D = $Alchemist


func _ready():
	if PlayerStats.slots == [null, null, null]:
		PlayerStats.get_start_spell()
	var player = find_child("Player")
	if player:
		PlayerStats.reset()
	spawn_point.spawn_player()
	GameStats.player_in_dungeon = false


func _process(delta):
	GameStats.total_time_played += delta


func _input(event):
	if event.is_action_pressed("test_save"):
		if SaveManager.can_save:
			SaveManager.save_game()
			SaveManager.game_save_result.emit(true)
		else:
			SaveManager.game_save_result.emit(false)
