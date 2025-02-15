extends CharacterBody2D
var bomb_scene = preload("res://Scenes/Items/Bomb/bomb.tscn")
@export var speed := 150
@export var min_knockback := 100
@export var slow_knockback := 1.1
var is_dead = false
var dying_animation_playing = false
var dying_animation_completed = false
var knockback: Vector2
signal hearts_changed(value)


func _ready():
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


func _physics_process(delta):
	if knockback.length() > min_knockback:
		knockback /= slow_knockback
		velocity = knockback
		move_and_slide()
		return
	
	if !is_dead:
		var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = input_direction * speed
	
	move_and_slide()
	update_direction()


func place_bomb():
	var bomb_instance = bomb_scene.instantiate()
	bomb_instance.global_position = global_position
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
