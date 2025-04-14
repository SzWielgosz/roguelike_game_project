extends Node
signal create_new_dungeon
var in_game: bool = false


func start_new_game():
	SaveManager.save_game()
	get_tree().change_scene_to_file("res://scenes/main/game.tscn")
