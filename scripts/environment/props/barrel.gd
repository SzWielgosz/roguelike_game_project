extends Node2D
var coin = preload("res://scenes/items/coin.tscn")
var is_destroyed: bool = false
@onready var navigation_obstacle: NavigationObstacle2D = $NavigationObstacle2D
signal destroyed


func _ready():
	if is_destroyed:
		destroy()
	else:
		$AnimatedSprite2D.play("idle")


func _on_area_2d_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("spell") or parent.is_in_group("explosive"):
		is_destroyed = true
		destroyed.emit()
		destroy()
		
		if randi() % 100 < 5:
			call_deferred("drop_coin")


func destroy():
	$NavigationObstacle2D.queue_free()
	$Area2D.queue_free()
	$StaticBody2D.queue_free()
	$AnimatedSprite2D.play("destroyed")


func drop_coin():
	var coin_instance = coin.instantiate()
	add_child(coin_instance)
	coin_instance.global_position = global_position
