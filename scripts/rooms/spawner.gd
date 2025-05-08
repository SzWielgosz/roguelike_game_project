extends Marker2D
class_name Spawner
@export var entity: PackedScene = null

func spawn_entity():
	if entity:
		var instance = entity.instantiate()
		add_child(instance)
		instance.global_position = global_position
