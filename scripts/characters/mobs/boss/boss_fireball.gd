extends Node2D

@export var speed: int = 200
@export var damage: float = 0.5
@export var knockback: float = 150.0
var direction: Vector2


func _ready():
	$AnimatedSprite2D.play("flying")


func _process(delta):
	position += direction * speed * delta


func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "hit":
		$DestroyTimer.start()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if body.get_node("PlayerHealth") != null:
			body.get_node("PlayerHealth").take_damage(damage)
	speed = 0
	$Area2D/CollisionShape2D.queue_free()
	$AnimatedSprite2D.play("hit")


func _on_destroy_timer_timeout():
	queue_free()


func set_direction(dir):
	direction = dir.normalized()
	rotation = direction.angle()
