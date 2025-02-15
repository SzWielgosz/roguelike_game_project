extends Node2D

@onready var marker = $Marker2D
var current_spell = null
var spell_requires_charging = false
var spell_done_charging = false
var spell_cooldown = 0


func _process(delta):
	look_at(get_global_mouse_position())
	if current_spell != null:
		if spell_requires_charging and !spell_done_charging:
			current_spell.global_position = marker.global_position
			var direction = (get_global_mouse_position() - current_spell.global_position).normalized()
			current_spell.set_direction(direction)


func _input(event):
	if event.is_action_pressed("use_spell"):
		var selected_spell = PlayerStats.get_selected_spell()
		if selected_spell:
			spell_requires_charging = selected_spell.requires_charge
			current_spell = selected_spell.cast_spell()
			if current_spell:
				get_tree().root.add_child(current_spell)
				current_spell.global_position = marker.global_position
				var direction = (get_global_mouse_position() - current_spell.global_position).normalized()
				current_spell.set_direction(direction)
				
	if event.is_action_released("use_spell"):
		current_spell = null
		spell_requires_charging = false
		spell_done_charging = false
