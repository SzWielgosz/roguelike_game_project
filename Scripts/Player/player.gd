extends CharacterBody2D
#150
@export var speed: int = 150
@export var stats: Stats

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed

func update_animation():
	if velocity != Vector2.ZERO:
		$AnimatedSprite2D.play("movement")
	else:
		$AnimatedSprite2D.play("idle")
		
func update_direction():
	var mouse_position = get_global_mouse_position()
	if mouse_position.x < global_position.x:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func _physics_process(_delta):
	get_input()
	move_and_slide()
	update_direction()

func _process(_delta):
	update_animation()
