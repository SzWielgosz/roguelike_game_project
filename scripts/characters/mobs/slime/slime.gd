extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var speed: int = 50
var direction: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO

func _ready():
	if animated_sprite_2d.material != null and !animated_sprite_2d.material.resource_local_to_scene:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
		animated_sprite_2d.material.resource_local_to_scene = true
	set_physics_process(true)

func _physics_process(_delta):
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
	velocity += knockback
	move_and_slide()
