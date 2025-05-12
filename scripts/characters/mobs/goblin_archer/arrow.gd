extends Node2D
@export var speed: int = 300
@export var knockback: float = 150.0
@export var attack_power: float = 0.5
var direction = Vector2.ZERO


func _process(delta):
	position += direction * speed * delta


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if body.get_node("PlayerHealth") != null:
			var damage = body.get_node("PlayerHealth").take_damage(attack_power)
			var knockback_direction = global_position.direction_to(body.global_position) * knockback
			body.knockback = knockback_direction
	speed = 0
	queue_free()
