extends Node
class_name Health

@export var max_health: int = 100
@export var defense = 10
@export var knockback_strength: Vector2 = Vector2(0, 0)
@export var immortality: bool = false
@export var damage = 0.5
@onready var health: int = max_health
var is_dead = false
var velocity = Vector2.ZERO
@onready var character_velocity = get_parent().velocity


func _process(delta):
	if health <= 0 and not is_dead:
		die()


func take_damage(damage: int) -> int:
	var actual_damage = max(damage - defense, 0)
	health -= actual_damage
	print("Mob took", actual_damage, "damage! HP left:", health)
	return actual_damage


func apply_knockback(force: Vector2, duration: float = 0.2):
	character_velocity += force


func die():
	is_dead = true
	get_parent().queue_free()
