extends Spell


func _on_cooldown_timer_timeout():
	is_on_cooldown = false
