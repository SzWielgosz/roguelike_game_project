extends Node2D
var coin = preload("res://scenes/items/coin.tscn")
@onready var navigation_obstacle: NavigationObstacle2D = $NavigationObstacle2D

signal destroyed


func _ready():
	$AnimatedSprite2D.play("idle")


func _on_timer_timeout():
	queue_free()


func _on_area_2d_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("spell") or parent.is_in_group("bomb"):
		$Area2D.queue_free()
		$StaticBody2D.queue_free()
		$NavigationObstacle2D.queue_free()
		$AnimatedSprite2D.play("destroyed")
		$Timer.start()
		destroyed.emit()	
		
		if randi() % 100 < 5:
			call_deferred("drop_coin")


func drop_coin():
	var coin_instance = coin.instantiate()
	get_parent().add_child(coin_instance)
	coin_instance.global_position = global_position
