extends Node2D
var neighbours: Dictionary = {
	"top": null,
	"down": null,
	"left": null,
	"right": null
}

func _on_room_area_body_entered(body):
	if body.is_in_group("player"):
		Events.room_entered.emit(self)
