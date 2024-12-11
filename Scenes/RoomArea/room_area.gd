extends Area2D
var doors_opened: bool = true
var room_cleared: bool = false


func _on_body_entered(body):
	if body.name == "Player":
		if room_cleared == false:
			if doors_opened:
				close_all_doors()
		else:
			if doors_opened == false:
				open_all_doors()
		
		
func open_all_doors():
	for door in $"../Doors".get_children():
		door.open_door()
	doors_opened = true
		
func close_all_doors():
	for door in $"../Doors".get_children():
		door.close_door()
	doors_opened = false	
