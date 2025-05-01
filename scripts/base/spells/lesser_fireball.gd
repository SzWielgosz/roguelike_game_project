extends InstantSpell

@export var speed: int = 200
@export var attack_power: float = 50.0 * PlayerStats.damage_modifier
@export var knockback: float = 150.0


func _ready():
	super._ready()
	$AnimatedSprite2D.play("flying")


func _process(delta):
	position += direction * speed * delta


func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "hit":
		$DestroyTimer.start()

func _on_area_2d_body_entered(body):
	if body.is_in_group("mobs"):
		if body.get_node("Health") != null:
			var damage = body.get_node("Health").take_damage(attack_power)
			var knockback_direction = global_position.direction_to(body.global_position) * knockback
			print(knockback_direction)
			body.knockback = knockback_direction
			print("Fireball hit! Damage:", damage)
	speed = 0
	$Area2D/CollisionShape2D.queue_free()
	$AnimatedSprite2D.play("hit")


func _on_destroy_timer_timeout():
	queue_free()
