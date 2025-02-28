extends Area2D

@export var speed: int = 200
@export var attack_power: int = 75
@export var knockback := 200
var direction = Vector2.ZERO


func _ready():
	$AnimatedSprite2D.play("flying")


func _process(delta):
	position += direction * speed * delta


func set_direction(dir):
	direction = dir.normalized()
	rotation = direction.angle() + deg_to_rad(90)


func _on_body_entered(body):
	if body.is_in_group("mobs"):
		if body.get_node("Health") != null:
			var damage = body.get_node("Health").take_damage(attack_power)
			print("Fireball hit! Damage:", damage)
	speed = 0
	$CollisionShape2D.queue_free()
	$AnimatedSprite2D.play("hit")


func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "hit":
		$Timer.start()


func _on_timer_timeout():
	queue_free()
