extends Node2D
var coin = preload("res://Scenes/Items/Coin/coin.tscn")

func _ready():
	$AnimatedSprite2D.play("idle")

func _on_timer_timeout():
	queue_free()

func _on_area_2d_area_entered(area):
	print(area)
	if area.is_in_group("spell"):
		$Area2D.queue_free()
		$StaticBody2D.queue_free()
		$AnimatedSprite2D.play("destroyed")
		$Timer.start()
		
		if randi() % 100 < 50:
			call_deferred("drop_coin")

func drop_coin():
	var coin_instance = coin.instantiate()
	get_parent().add_child(coin_instance)
	coin_instance.global_position = global_position
