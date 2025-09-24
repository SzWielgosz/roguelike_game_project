extends Node2D
@onready var navigation_obstacle_2d: NavigationObstacle2D = $NavigationObstacle2D
@onready var area2d: Area2D = $Area2D
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var is_destroyed: bool = false
signal destroyed


func _ready():
	animated_sprite_2d.play("idle")

func _on_area_2d_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("explosive"):
		navigation_obstacle_2d.queue_free()
		area2d.queue_free()
		static_body_2d.queue_free()
		animated_sprite_2d.play("destroyed")
		is_destroyed = true
		destroyed.emit()	

func destroy():
	$NavigationObstacle2D.queue_free()
	$Area2D.queue_free()
	$StaticBody2D.queue_free()
	$AnimatedSprite2D.play("destroyed")
