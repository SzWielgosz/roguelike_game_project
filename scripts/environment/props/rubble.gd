extends Node2D
@onready var navigation_obstacle_2d: NavigationObstacle2D = $NavigationObstacle2D
@onready var area2d: Area2D = $Area2D
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var destroy_timer: Timer = $DestroyTimer
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
		destroy_timer.start()
		destroyed.emit()	


func _on_destroy_timer_timeout():
	queue_free()
