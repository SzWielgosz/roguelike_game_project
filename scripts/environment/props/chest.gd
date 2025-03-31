extends RigidBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
var is_opened: bool = false


func _process(delta):
	if !is_opened:
		animated_sprite_2d.play("closed")
	else:
		animated_sprite_2d.play("opened")


func _on_open_area_2d_body_entered(body):
	is_opened = true
