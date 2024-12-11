extends Node2D

var flying_eye_scene = preload("res://Scenes/Mobs/FlyingEye/flying_eye.tscn")


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		for spawn_point in $"../SpawnPoints".get_children():
			var flying_eye = flying_eye_scene.instantiate()
			flying_eye.global_position = spawn_point.global_position
			get_tree().root.call_deferred("add_child", flying_eye)
