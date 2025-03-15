extends Resource
class_name DestroyableStats

@export var health: int = 20


func take_damage(damage: int) -> void:
	health -= damage
	
