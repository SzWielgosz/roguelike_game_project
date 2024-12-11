extends Node2D

@onready var generator = $DungeonGenerator

func _ready():
	generator.create_map()

