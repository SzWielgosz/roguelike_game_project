extends CharacterBody2D
var bomb_scene = preload("res://scenes/items/bomb.tscn")
@export var speed := 150
@export var min_knockback := 100
@export var slow_knockback := 1.1
@export var dash_speed = 1000
@export var push_force = 10.0
var is_dead = false
var can_dash = true
var is_dashing = false
var dying_animation_playing = false
var dying_animation_completed = false
var knockback: Vector2
var dash_direction: Vector2
signal hearts_changed(value)
signal dash_active


func _ready():
	if SaveManager.save_data != null:
		global_position = SaveManager.save_data.player_position
	PlayerStats.set_player(self)
	set_collision_mask_value(6, true)
	set_collision_mask_value(11, true)
	$HUD.visible = true
	PlayerStats.health_changed.connect(_on_health_changed)
	PlayerStats.set_health(PlayerStats.player_health)


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
		if is_dashing:
			$AnimatedSprite2D.play("dash")
		else:
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
		return
	
	if !is_dead:
		if is_dashing:
			velocity = dash_direction * dash_speed
		else:	
			var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			velocity = input_direction * speed
			
			if Input.is_action_just_pressed("dash") and can_dash and input_direction != Vector2.ZERO:
				start_dash(input_direction)
	
	move_and_slide()
	update_direction()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)


func start_dash(direction):
	dash_active.emit()
	is_dashing = true
	can_dash = false
	dash_direction = direction.normalized()
	velocity = dash_direction * dash_speed
	$DashParticles.emitting = true
	$DashTimer.start()
	$HUD.start_dash_cooldown($DashCooldownTimer.wait_time)


func place_bomb():
	var bomb_instance = bomb_scene.instantiate()
	bomb_instance.global_position = global_position
	GameStats.bombs_used += 1
	get_parent().add_child(bomb_instance)


func _process(_delta):
	if Input.is_action_just_pressed("use_bomb"):
		if PlayerStats.player_bombs > 0:
			place_bomb()
			PlayerStats.substract_bomb(1)
	update_animation()


func _on_death_timer_timeout():
	dying_animation_completed = true


func _on_health_changed(health_value):
	hearts_changed.emit(health_value)


func _on_player_health_player_died():
	is_dead = true


func _on_dash_timer_timeout():
	is_dashing = false
	velocity = Vector2.ZERO
	$DashParticles.emitting = false
	$DashCooldownTimer.start()


func _on_dash_cooldown_timer_timeout():
	can_dash = true
