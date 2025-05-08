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
	for spawn_point in get_parent().get_node("RoomLayout").get_child(0).get_node("NavigationRegion2D").get_node("SpawnPoints").get_children():
		spawn_point.call_deferred("spawn_entity")


func _on_room_area_spawn_chest():
	if Utils.get_child_or_null(self.get_parent().get_node("RoomLayout"), 0) != null:
		var chest_spawner = self.get_parent().get_node("RoomLayout").get_child(0).get_node("NavigationRegion2D").get_node_or_null("ChestSpawner")
		if chest_spawner:
			if GameStats.random_number_generator.randf() < GameStats.chest_spawn_probability:
				chest_spawner.call_deferred("spawn_entity")
