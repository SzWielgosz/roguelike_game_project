extends Node2D
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
	for spawn_point in get_parent().get_node("RoomPattern").get_child(0).get_child(0).get_node("SpawnPoints").get_children():
		spawn_point.spawn_mob()
		#var goblin = goblin_scene.instantiate()
		#goblin.global_position = spawn_point.global_position
		#get_tree().root.call_deferred("add_child", goblin)
