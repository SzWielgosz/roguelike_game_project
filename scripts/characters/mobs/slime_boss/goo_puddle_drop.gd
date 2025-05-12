extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var timer: Timer = $Timer

func _ready():
	timer.start()
	animated_sprite_2d.play("drop")
	collision_shape_2d.disabled = true

func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.play("dropped")
	collision_shape_2d.disabled = false

func _on_timer_timeout():
	queue_free()
