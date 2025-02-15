extends Node

class_name Spell  

@export var requires_charge: bool
@export var spell_scene: PackedScene


signal spell_casted(spell_instance)


func cast_spell():
	if spell_scene:
		var spell_instance = spell_scene.instantiate()
		spell_casted.emit(spell_instance)
		return spell_instance
	else:
		print("Brak przypisanej sceny zaklęcia!")
		return null
