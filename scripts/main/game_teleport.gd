extends Sprite2D
@onready var label = $Label
var player_inside: bool = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		label.visible = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		label.visible = false


func _input(event):
	if event.is_action_pressed("interact"):
		if player_inside:
			GameManager.start_new_game()
