extends Node2D

var fireball_scene = preload("res://Scenes/Magic/Tier0/Fireball/fireball.tscn")

func _process(delta):
	look_at(get_global_mouse_position())

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var fireball = fireball_scene.instantiate()
		fireball.rotation = rotation + deg_to_rad(90)
		get_tree().root.add_child(fireball)
		fireball.global_position = $"Marker2D".global_position
		var direction = (get_global_mouse_position() - fireball.global_position)
		fireball.set_direction(direction)
		
