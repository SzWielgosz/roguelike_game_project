extends Node2D

var fireball_scene = preload("res://Scenes/Magic/Tier0/Fireball/fireball.tscn")
var flamespray_scene = preload("res://Scenes/Magic/Tier0/FlameSpray/flamespray.tscn")
var flamespray = null

func _process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("use_spell"):
		if flamespray == null:
			flamespray = flamespray_scene.instantiate()
			get_tree().root.add_child(flamespray)
		flamespray.global_position = $"Marker2D".global_position
		var direction = (get_global_mouse_position() - flamespray.global_position).normalized()
		print(direction)
		flamespray.get_node("GPUParticles2D").process_material.gravity = Vector3(direction.x * 1200, direction.y * 1200, 0)

	else:
		if flamespray != null:
			flamespray.queue_free()
			flamespray = null

func _input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#var fireball = fireball_scene.instantiate()
		#fireball.rotation = rotation + deg_to_rad(90)
		#get_tree().root.add_child(fireball)
		#fireball.global_position = $"Marker2D".global_position
		#var direction = (get_global_mouse_position() - fireball.global_position)
		#fireball.set_direction(direction)
		
	#if event.is_action_pressed("use_spell"):
		#var fireball = flamespray.instantiate()
		#get_tree().root.add_child(fireball)
		#fireball.global_position = $"Marker2D".global_position
	pass

