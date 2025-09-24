extends Node2D
@onready var generator: Node2D = $DungeonGenerator
@onready var reset_timer: Timer = $ResetTimer
var holding_reset = false


func _ready():
	GameStats.player_in_dungeon = true
	generator.create_dungeon()


func _process(delta):
	GameStats.time_played += delta
	GameStats.total_time_played += delta
	
	if GameStats.dungeon_number >= 3:
		get_tree().change_scene_to_file("res://scenes/rooms/boss_room.tscn")


func _input(event):
	if event.is_action_pressed("reset"):
		holding_reset = true
		reset_timer.start()
	if event.is_action_released("reset"):
		holding_reset = false
	if event.is_action_pressed("test_save"):
		if SaveManager.can_save:
			SaveManager.save_game()
			SaveManager.game_save_result.emit(true)
		else:
			SaveManager.game_save_result.emit(false)


func reset():
	get_tree().reload_current_scene()
	PlayerStats.reset()


func _on_reset_timer_timeout():
	if holding_reset:
		reset()

