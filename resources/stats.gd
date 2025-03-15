extends Resource
class_name Stats

@export var attack: int = 100
@export var health: int = 100
@export var defense: int = 0

signal died

func take_damage(damage: int) -> int:
	var actual_damage = max(damage - defense, 0)
	health -= actual_damage
	return actual_damage
