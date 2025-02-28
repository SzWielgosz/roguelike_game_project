extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@export var speed: int = 80
var direction: Vector2 = Vector2.ZERO

func _ready():
	set_physics_process(true)

func _process(_delta):
	if direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false

func _physics_process(delta):
	velocity = direction.normalized() * speed
	move_and_slide()
