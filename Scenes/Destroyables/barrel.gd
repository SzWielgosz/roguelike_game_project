extends Node2D


func _ready():
	$AnimatedSprite2D.play("idle")


func _on_timer_timeout():
	queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("spell"):
		$Area2D.queue_free()
		$StaticBody2D.queue_free()
		$AnimatedSprite2D.play("destroyed")
		$Timer.start()
