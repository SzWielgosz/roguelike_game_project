extends CharacterBody2D
@export var speed: int = 150
@export var min_knockback := 100
@export var slow_knockback := 1.1
var hearts
var max_hearts
var is_dead = false
var dying_animation_playing = false
var dying_animation_completed = false
var knockback: Vector2
signal hearts_changed(value)


func _ready():
	hearts = $PlayerHealth.health
	max_hearts = $PlayerHealth.max_health


func get_input():
	if is_dead:
		return
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed


func update_animation():
	if is_dead:
		if not dying_animation_playing:
			$AnimatedSprite2D.play("dying")
			dying_animation_playing = true
			$DeathTimer.start()
		if dying_animation_completed:
			$AnimatedSprite2D.play("dead")
		return

	if velocity != Vector2.ZERO:
		$AnimatedSprite2D.play("movement")
	else:
		$AnimatedSprite2D.play("idle")


func update_direction():
	if !is_dead:
		var mouse_position = get_global_mouse_position()
		if mouse_position.x < global_position.x:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false


func _physics_process(_delta):
	if knockback.length() > min_knockback:
		knockback /= slow_knockback
		velocity = knockback
		move_and_slide()
		return
	
	get_input()
	move_and_slide()
	update_direction()


func _process(_delta):
	update_animation()


func _on_death_timer_timeout():
	dying_animation_completed = true


func _on_player_health_health_changed(health_value):
	hearts_changed.emit(health_value)


func _on_player_health_player_died():
	is_dead = true
