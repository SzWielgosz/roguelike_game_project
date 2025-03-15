extends Node2D
@onready var spawn_point: Marker2D = $SpawnPoint


func _ready():
	spawn_point.spawn_player()
