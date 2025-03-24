extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var speed: int = 80
var direction: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var is_dashing: bool = false


func _ready():
	set_physics_process(true)

func _process(_delta):
	if direction.x < 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false

func _physics_process(_delta):
	if not is_dashing:
		velocity = direction.normalized() * speed + knockback
		
	move_and_slide()
	knockback = knockback.lerp(Vector2.ZERO, 0.1)
