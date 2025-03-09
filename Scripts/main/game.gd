extends Node2D
@onready var generator = $RoomGenerator
@onready var reset_timer: Timer = $ResetTimer
var holding_reset = false

func _ready():
	generator.create_map()


func _input(event):
	if event.is_action_pressed("reset"):
		holding_reset = true
		reset_timer.start()
	if event.is_action_released("reset"):
		holding_reset = false


func reset():
	get_tree().reload_current_scene()
	PlayerStats.reset()


func _on_reset_timer_timeout():
	if holding_reset:
		reset()
