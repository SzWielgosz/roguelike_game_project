extends Marker2D
class_name MobSpawner

@export var mob: PackedScene = null

func spawn_mob():
	if mob:
		var mob_instance = mob.instantiate()
		add_child(mob_instance)
		mob_instance.global_position = global_position
