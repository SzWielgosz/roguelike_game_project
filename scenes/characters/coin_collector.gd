extends Node2D
var player_nearby: bool = false
@onready var label: Label = $Label


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		label.visible = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		label.visible = false


func _input(event):
	if event.is_action_pressed("interact"):
		if PlayerStats.player_coins > 0 and player_nearby:
			PlayerStats.coins_deposited += 1
			PlayerStats.player_coins -= 1
			PlayerStats.coin_deposited.emit(PlayerStats.player_coins)
