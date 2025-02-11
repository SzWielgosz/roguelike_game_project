extends Node2D


func _on_room_area_body_entered(body):
	if body.is_in_group("player"):
		print("Player entered")
		Events.room_entered.emit(self)
