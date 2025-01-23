extends CanvasLayer
var empty_heart = preload("res://Scenes/UI/Hearts/empty_heart.tscn")
var full_heart = preload("res://Scenes/UI/Hearts/full_heart.tscn")
var half_heart = preload("res://Scenes/UI/Hearts/half_heart.tscn")
@onready var player = $"../Player"
@onready var health = player.health
@onready var max_health = player.max_health

func _ready():
	for i in range(max_health):
		if health > 1:
			$HBoxContainer/VBoxContainer/Health/HBoxContainer.add_child(full_heart)
			health -= 1
		elif health == 0.5:
			$HBoxContainer/VBoxContainer/Health/HBoxContainer.add_child(half_heart)
			health -= 0.5
		else:
			$HBoxContainer/VBoxContainer/Health/HBoxContainer.add_child(empty_heart)
	
