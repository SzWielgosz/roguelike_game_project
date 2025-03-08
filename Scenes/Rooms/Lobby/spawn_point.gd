extends Marker2D
@export var player: PackedScene = null


func spawn_player():
	if player:
		var player_instance = player.instantiate()
		$"..".add_child(player_instance)
		player_instance.global_position = global_position
