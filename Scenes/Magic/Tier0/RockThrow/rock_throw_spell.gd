extends Spell


func _ready():
	spell_scene = preload("res://Scenes/Magic/Tier0/RockThrow/rock_throw.tscn")
	requires_charge = true
