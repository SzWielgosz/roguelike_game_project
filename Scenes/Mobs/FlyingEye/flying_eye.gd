extends CharacterBody2D

@export var speed: int = 75
@export var knockback_resistance: float = 1
@export var knockback := 200
var is_dead: bool = false
var chase_player: bool = false
var player = null
var damage_value = 0.5


func _ready():
	$"AnimatedSprite2D".play("default")


func _physics_process(delta):
	if chase_player:
		if player and player.is_dead:
			chase_player = false
			velocity = Vector2.ZERO
			return

		var direction = (player.position-position).normalized()
		velocity= direction * speed
		move_and_slide()

		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false


func _on_detection_range_body_entered(body):
	if body.is_in_group("player"):
		player = body
		chase_player = true


func _on_detection_range_body_exited(body):
	if body.is_in_group("player"):
		player = null
		chase_player = false


func _on_hit_box_body_entered(body):
	if body.is_in_group("player"):
		var player_health = body.get_node("PlayerHealth")
		if body.is_dead == false:
			player_health.take_damage(damage_value, position.direction_to(body.position) * knockback)
		else:
			body.knockback = Vector2.ZERO
			body.velocity = Vector2.ZERO
