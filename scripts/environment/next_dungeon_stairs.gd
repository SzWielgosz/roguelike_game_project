extends Node2D


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		call_deferred("_reload_scene")

func _reload_scene():
	GameStats.random_number_generator.randomize()
	GameStats.dungeon_number += 1
	PlayerStats.treasure_collected = false
	SaveManager.dungeon_to_load = false
	get_tree().current_scene.get_node("DungeonGenerator").create_dungeon()
