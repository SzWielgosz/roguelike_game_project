extends Node2D
class_name  Spell
var direction = Vector2.ZERO
var cast_position = Vector2.ZERO
signal cast


func set_direction(dir):
	direction = dir.normalized()
	rotation = direction.angle()
