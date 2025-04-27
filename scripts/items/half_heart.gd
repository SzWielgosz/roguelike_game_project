extends Node2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if PlayerStats.player_health < PlayerStats.player_max_health:
			PlayerStats.set_health(PlayerStats.player_health + 0.5)
			queue_free()
