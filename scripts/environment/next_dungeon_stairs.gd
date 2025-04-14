extends Node2D


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		call_deferred("_reload_scene")

func _reload_scene():
	GameStats.random_number_generator.randomize()
	GameStats.dungeon_number += 1
	SaveManager.dungeon_to_load = false
	get_tree().get_root().get_node("Game").get_node("DungeonGenerator").create_dungeon()
