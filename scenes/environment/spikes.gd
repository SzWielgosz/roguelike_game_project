extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $"."
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var rise_timer: Timer = $RiseTimer
@onready var fall_timer: Timer = $FallTimer
@onready var state_timer: Timer = $StateTimer


func _ready():
	if animated_sprite_2d.animation == "fallen":
		animated_sprite_2d.play("rise")
		rise_timer.start()
	elif animated_sprite_2d.animation == "risen":
		animated_sprite_2d.play("fall")
		fall_timer.start()


func _on_rise_timer_timeout():
	state_timer.start()
	animated_sprite_2d.play("risen")
	collision_shape_2d.disabled = false


func _on_fall_timer_timeout():
	state_timer.start()
	animated_sprite_2d.play("fallen")
	collision_shape_2d.disabled = true


func _on_state_timer_timeout():
	if animated_sprite_2d.animation == "risen":
		animated_sprite_2d.play("fall")
		fall_timer.start()
	else:
		animated_sprite_2d.play("rise")
		rise_timer.start()
