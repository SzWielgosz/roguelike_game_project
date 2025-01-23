extends Resource

@export var damage: int = 25
@export var cooldown: float = 1.0

func cast(user: Node, marker: Node, position: Vector2):
	var fireball_scene = preload("res://Scenes/Magic/Tier0/Fireball/fireball.tscn")
	var fireball_instance = fireball_scene.instance()

	fireball_instance.global_position = marker.global_position
	fireball_instance.target_position = position
	fireball_instance.damage = damage

	user.get_tree().current_scene.add_child(fireball_instance)
