extends Spell
class_name InstantSpell

func _ready():
	cast.emit()
