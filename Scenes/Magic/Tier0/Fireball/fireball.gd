extends Area2D

@export var speed: int = 200
@export var attack_power: int = 20
@export var knockback_force: Vector2 = Vector2(300, 0)
var direction = Vector2.ZERO


func _ready():
	$AnimatedSprite2D.play("flying")


func _process(delta):
	position += direction * speed * delta


func set_direction(dir):
	direction = dir.normalized()


func _on_body_entered(body):
	if body.name == "TileMap" or body.name == "StaticBody2D":
		speed = 0
		$AnimatedSprite2D.play("hit")
	if body.has_method("take_damage"):
		var damage = body.take_damage(attack_power)
		print("Fireball hit! Damage:", damage)
		$AnimatedSprite2D.play("hit")



func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "hit":
		$Timer.start()


func _on_timer_timeout():
	queue_free()
