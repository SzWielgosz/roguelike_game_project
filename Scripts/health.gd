class_name Health
extends Node


signal max_health_changed(diff :int)
signal health_changed(diff: int)
signal health_depleted

@export var max_health: int = 5
@export var immortality: bool = false
@onready var health: int = max_health

var immortality_time: Timer = null


func set_max_health(value: int):
	var clamped_value = 1 if value <= 0 else value
	
	if not clamped_value == max_health:
		var difference = clamped_value - max_health
		max_health_changed.emit(difference)
		
	if health > max_health:
		health = max_health


func get_max_health():
	return max_health


func set_health(value: int):
	print("set_health")
	if value < health and immortality:
		return
		
	var clamped_value = clampi(value, 0, max_health)

func get_health():
	return health


func set_immortality(value: bool):
	immortality = value


func get_immortality():
	return immortality
