extends Node2D

@onready var marker = $Marker2D
@onready var hud = $"../HUD"
@onready var casted_spells = $CastedSpells
var current_spell_scroll: SpellScroll = null
var current_spell: Spell = null

func _process(_delta):
	look_at(get_global_mouse_position())
	if current_spell != null:
		if current_spell_scroll.cast_type == current_spell_scroll.CastType.CHANNEL:
			current_spell.global_position = marker.global_position
			var direction = (get_global_mouse_position() - current_spell.global_position).normalized()
			current_spell.set_direction(direction)

func _input(event):
	if event.is_action_pressed("use_spell"):
		current_spell_scroll = PlayerStats.get_selected_spell()
		if current_spell_scroll:
			current_spell = current_spell_scroll.cast_spell()
			if current_spell:
				GameStats.spells_casted += 1
				current_spell.cast.connect(_on_spell_cast)
				casted_spells.add_child(current_spell)
				current_spell.global_position = marker.global_position
				var direction = (get_global_mouse_position() - current_spell.global_position).normalized()
				current_spell.set_direction(direction)

	if event.is_action_released("use_spell"):
		current_spell = null


func _on_spell_cast():
	hud.start_spell_cooldown()
