extends Node
var first_time_playing: bool = true
var player_in_dungeon: bool = false
var total_time_played: float = 0.0
var time_played: float = 0.0
var mobs_killed: int = 0
var coins_collected: int = 0
var bombs_used: int = 0
var spells_casted: int = 0
var dungeon_number: int = 0
var player_clearing_room: bool = false
var random_number_generator: RandomNumberGenerator = RandomNumberGenerator.new()
var chest_spawn_probability: float = 0.5


func _ready():
	pass


func _on_loaded_game():
	total_time_played = SaveManager.save_data.total_time_played


func reset():
	mobs_killed = 0
	coins_collected = 0
	time_played = 0.0
	bombs_used = 0
	spells_casted = 0
	dungeon_number = 0
