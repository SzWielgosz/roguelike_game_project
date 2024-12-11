extends CharacterBody2D

@export var speed: int = 75
@export var stats: Stats
var is_dead: bool = false
var chase_player: bool = false
var player = null


func _ready():
	stats = stats.duplicate(true)
	$"AnimatedSprite2D".play("default")


func _physics_process(delta):
	if chase_player:
		var direction = (player.position-position).normalized()
		
		velocity= direction * speed
		move_and_slide()

		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false


func _process(delta):
	if stats.health <= 0 and not is_dead:
		die()


func _on_detection_range_body_entered(body):
	if body.name == "Player":
		player = body
		chase_player = true


func _on_detection_range_body_exited(body):
	if body.name == "Player":
		player = null
		chase_player = false


func take_damage(damage: int) -> int:
	if stats:
		var actual_damage = stats.take_damage(damage)
		print("Mob took", actual_damage, "damage! HP left:", stats.health)
		return actual_damage
	return 0


func die():
	is_dead = true
	stats.emit_signal("died")
	queue_free()
