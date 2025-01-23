extends CanvasLayer
var empty_heart = preload("res://Scenes/UI/Hearts/empty_heart.tscn")
var full_heart = preload("res://Scenes/UI/Hearts/full_heart.tscn")
var half_heart = preload("res://Scenes/UI/Hearts/half_heart.tscn")
@onready var player = $"../Player"
@onready var hearts = player.hearts
@onready var max_hearts = player.max_hearts


func set_hearts(value):
	var hearts = value
	var children = $HBoxContainer/VBoxContainer/Health/HBoxContainer.get_children()
	for child in children:
		child.queue_free()
		
	for i in range(max_hearts):
		if hearts >= 1:
			var full_heart_instance = full_heart.instantiate()
			$HBoxContainer/VBoxContainer/Health/HBoxContainer.add_child(full_heart_instance)
			hearts -= 1
		elif hearts == 0.5:
			var half_heart_instance = half_heart.instantiate()
			$HBoxContainer/VBoxContainer/Health/HBoxContainer.add_child(half_heart_instance)
			hearts -= 0.5
		else:
			var empty_heart_instance = empty_heart.instantiate()
			$HBoxContainer/VBoxContainer/Health/HBoxContainer.add_child(empty_heart_instance)


func _ready():
	set_hearts(hearts)


func _on_player_hearts_changed(value):
	set_hearts(value)
