extends Node2D

var flying_eye_scene = preload("res://Scenes/Mobs/FlyingEye/flying_eye.tscn")
@onready var timer = Timer.new()


func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)


func _on_room_area_spawn_mobs():
	timer.start()


func _on_timer_timeout():
	spawn_mobs()


func spawn_mobs():
	print("Spawning mobs")
	for spawn_point in get_parent().get_node("RoomPattern").get_child(0).get_node("SpawnPoints").get_children():
		var flying_eye = flying_eye_scene.instantiate()
		flying_eye.global_position = spawn_point.global_position
		get_tree().root.call_deferred("add_child", flying_eye)
