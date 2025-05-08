extends Node
class_name RoomManager

signal cleared_room
var entities: Array
var cleared: bool = false
var spawn_chest_tried: bool = false
var delay_timer: Timer = Timer.new()

func _ready():
	self.cleared_room.connect(_on_cleared_room)
	delay_timer.one_shot = true

func _process(delta):
	entities = get_parent().get_node("RoomArea").get_overlapping_bodies()
	if entities != []:
		for entity in entities:
			if entity.is_in_group("mobs"):
				print(entities)
				break
			else:
				cleared = true
				cleared_room.emit()

func spawn_chest_probability():
	if Utils.get_child_or_null(self.get_parent().get_node("RoomLayout"), 0) != null:
		print("Aktualny room: ", self.get_parent())
		var chest_spawner = self.get_parent().get_node("RoomLayout").get_child(0).get_node("NavigationRegion2D").get_node_or_null("ChestSpawner")
		print("Poszło")
		if chest_spawner:
			if GameStats.random_number_generator.randf() < GameStats.chest_spawn_probability:
				chest_spawner.spawn_entity()

func _on_cleared_room():
	if cleared:
		if !spawn_chest_tried:
			spawn_chest_probability()
			spawn_chest_tried = true
