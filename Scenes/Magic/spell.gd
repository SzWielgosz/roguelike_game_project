extends Node

class_name Spell  

@export var requires_charge: bool
@export var spell_scene: PackedScene
@export var is_on_cooldown: bool = false
@export var cooldown_timer: Timer



func cast_spell():
	if spell_scene and !is_on_cooldown:
		var spell_instance = spell_scene.instantiate()
		is_on_cooldown = true
		cooldown_timer.start()
		return spell_instance
	else:
		return null
