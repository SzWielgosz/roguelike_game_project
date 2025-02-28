extends Spell

var current_rock_throw


func cast_spell():
	if spell_scene and !is_on_cooldown:
		var spell_instance = spell_scene.instantiate()
		current_rock_throw = spell_instance
		current_rock_throw.rock_throw_finished.connect(_on_rock_throw_finished)
		is_on_cooldown = true
		return spell_instance
	else:
		return null


func _on_rock_throw_finished():
	cooldown_timer.start()


func _on_cooldown_timer_timeout():
	is_on_cooldown = false
