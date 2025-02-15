extends Spell


func _ready():
	spell_scene = preload("res://Scenes/Magic/Tier0/Fireball/fireball.tscn")
	requires_charge = false
