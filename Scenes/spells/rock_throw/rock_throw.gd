extends Area2D

@export var speed: int = 150
@export var attack_power: int = 150
var direction = Vector2.ZERO
var channeled: bool = false
var holding: bool = true
var thrown: bool = false
var collided: bool = false
var throw_rotation: float = 0.0

signal rock_throw_finished


func _ready():
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate(true)
	if !channeled:
		$AnimatedSprite2D.play("channel")
		$ChannelTimer.start()


func _process(delta):
	if !holding and !channeled:
		queue_free()

	if holding and channeled and !thrown:
		rotation += 1 * delta 

	if thrown:
		position += direction * speed * delta


func _input(event):
	if event.is_action_released("use_spell"):
		rock_throw_finished.emit()
		if channeled:
			$CollisionShape2D.disabled = false
			throw_rotation = rotation
			thrown = true
		else:
			queue_free()


func set_direction(dir):
	direction = dir.normalized()
	rotation = direction.angle()


func _on_charge_timer_timeout():
	$AnimatedSprite2D.play("idle")
	channeled = true


func _on_body_entered(body):
	if body.name == "TileMap" or body.name == "StaticBody2D":
		destroy()


	if body.is_in_group("mobs"):
		if body.get_node("Health") != null: 
			var damage = body.get_node("Health").take_damage(attack_power)
			print("Rock throw hit! Damage:", damage)
			destroy()


func destroy():
	speed = 0
	$AnimatedSprite2D.play("destroy")
	$CollisionShape2D.position = Vector2(7, 0)
	$CollisionShape2D.shape.radius = 14
	$CollisionShape2D.shape.height = 36


func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "destroy":
		collided = true
		$DestroyTimer.start()


func _on_destroy_timer_timeout():
	queue_free()
