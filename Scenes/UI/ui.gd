extends CanvasLayer
var empty_heart = preload("res://Scenes/UI/Hearts/empty_heart.tscn")
var full_heart = preload("res://Scenes/UI/Hearts/full_heart.tscn")
var half_heart = preload("res://Scenes/UI/Hearts/half_heart.tscn")
@onready var player = $"../Player"
@onready var health = PlayerStats.player_health
@onready var max_hearts = PlayerStats.player_max_health
@onready var gold = PlayerStats.player_gold
@onready var bombs = PlayerStats.player_bombs
@onready var spell_slots = PlayerStats.slots


func set_hearts(value):
	var children = $HBoxContainer/VBoxContainer/Health/HBoxContainer.get_children()
	for child in children:
		child.queue_free()
		
	for i in range(max_hearts):
		if value >= 1:
			var full_heart_instance = full_heart.instantiate()
			$HBoxContainer/VBoxContainer/Health/HBoxContainer.add_child(full_heart_instance)
			value -= 1
		elif value == 0.5:
			var half_heart_instance = half_heart.instantiate()
			$HBoxContainer/VBoxContainer/Health/HBoxContainer.add_child(half_heart_instance)
			value -= 0.5
		else:
			var empty_heart_instance = empty_heart.instantiate()
			$HBoxContainer/VBoxContainer/Health/HBoxContainer.add_child(empty_heart_instance)
			

func set_gold(value):
	$HBoxContainer/VBoxContainer/CoinCounter/HBoxContainer/Label.text = str(PlayerStats.player_gold)


func set_bombs(value):
	$HBoxContainer/VBoxContainer/BombCounter/HBoxContainer/Label.text = str(PlayerStats.player_bombs)


func set_spells(slots):
	var number = 1
	for spell in slots:
		if spell:
			$HBoxContainer/VBoxContainer/SpellSlots/HBoxContainer.get_node("Slot" + str(number)).get_node("TextureRect").texture = spell.get_node("Sprite2D").texture
		number += 1


func _ready():
	set_hearts(health)
	set_gold(gold)
	set_bombs(bombs)
	set_spells(spell_slots)
	
	PlayerStats.health_changed.connect(_on_health_changed)
	PlayerStats.gold_changed.connect(_on_gold_changed)
	PlayerStats.bombs_changed.connect(_on_bombs_changed)


func _on_health_changed(value):
	set_hearts(value)

func _on_gold_changed(value):
	set_gold(value)
	
func _on_bombs_changed(value):
	set_bombs(value)
