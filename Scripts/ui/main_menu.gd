extends CanvasLayer
@onready var main_buttons = $NinePatchRect/MainButtons
@onready var options = $NinePatchRect/Options
@onready var credits = $NinePatchRect/Credits


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/rooms/lobby.tscn")


func _on_options_button_pressed():
	main_buttons.visible = false
	options.visible = true


func _on_options_back_pressed():
	main_buttons.visible = true
	options.visible = false


func _on_credits_button_pressed():
	main_buttons.visible = false
	credits.visible = true


func _on_credits_back_pressed():
	main_buttons.visible = true
	credits.visible = false


func _on_quit_button_pressed():
	get_tree().quit()

