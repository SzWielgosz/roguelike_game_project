extends Node2D
@onready var door: Sprite2D = $Door
@onready var summary: CanvasLayer = $Summary
@onready var camera2d: Camera2D = $Camera2D
var player_inside: bool = false
var mobs_left: Array = []


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		door.close_door()
		player_inside = true

	if body.is_in_group("mobs"):
		mobs_left.append(body)


func _on_area_2d_body_exited(body):
	if body.is_in_group("mobs"):
		mobs_left.erase(body)
	
	if mobs_left.is_empty():
		summary.create_summary()
