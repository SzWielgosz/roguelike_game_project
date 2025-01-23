extends Node
class_name Health


signal max_health_changed(diff :int)
signal health_changed(diff: int)
signal health_depleted
signal died

@export var max_health: int = 100
@export var defense = 10
@export var knockback_strength: Vector2 = Vector2(0, 0)
@export var immortality: bool = false
@onready var health: int = max_health
var is_dead = false
var velocity = Vector2.ZERO
var immortality_time: Timer = null
@onready var character_velocity = get_parent().velocity


func _process(delta):
	if health <= 0 and not is_dead:
		die()


#func _physics_process(delta):
	#if get_parent().has_method("move_and_slide"):
		#character_velocity = get_parent().move_and_slide()
		#character_velocity = velocity.lerp(Vector2.ZERO, 0.1) 
	#else:
		#character_velocity = Vector2.ZERO


func set_max_health(value: int):
	var clamped_value = 1 if value <= 0 else value
	
	if not clamped_value == max_health:
		var difference = clamped_value - max_health
		max_health_changed.emit(difference)
		
	if health > max_health:
		health = max_health


func get_max_health():
	return max_health


func set_health(value: int):
	if value < health and immortality:
		return
		
	var clamped_value = clampi(value, 0, max_health)
	

func take_damage(damage: int) -> int:
	var actual_damage = max(damage - defense, 0)
	health -= actual_damage
	print("Mob took", actual_damage, "damage! HP left:", health)
	return actual_damage
	

func apply_knockback(force: Vector2, duration: float = 0.2):
	character_velocity += force


func get_health():
	return health


func set_immortality(value: bool):
	immortality = value


func get_immortality():
	return immortality


func die():
	is_dead = true
	get_parent().queue_free()
