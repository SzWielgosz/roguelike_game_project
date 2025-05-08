extends CanvasLayer
var empty_heart = preload("res://scenes/ui/empty_heart.tscn")
var full_heart = preload("res://scenes/ui/full_heart.tscn")
var half_heart = preload("res://scenes/ui/half_heart.tscn")
@onready var health = PlayerStats.player_health
@onready var max_hearts = PlayerStats.player_max_health
@onready var coins = PlayerStats.player_coins
@onready var bombs = PlayerStats.player_bombs
@onready var spell_slots = PlayerStats.slots
var current_selected_spell: int = PlayerStats.selected_slot + 1
var previous_selected_spell: int = PlayerStats.selected_slot + 1


func _input(event):
	if event.is_action_pressed("select_first_spell"):
		current_selected_spell = 1
	elif event.is_action_pressed("select_second_spell"):
		current_selected_spell = 2
	elif event.is_action_pressed("select_third_spell"):
		current_selected_spell = 3

	select_spell()


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


func set_coins(value):
	$HBoxContainer/VBoxContainer/CoinCounter/HBoxContainer/Label.text = str(PlayerStats.player_coins)


func set_bombs(value):
	$HBoxContainer/VBoxContainer/BombCounter/HBoxContainer/Label.text = str(PlayerStats.player_bombs)


func set_spells(slots):
	var number = 1
	for spell in slots:
		print("Current spell: ", spell)
		if spell != null:
			$HBoxContainer/VBoxContainer/SpellSlots/HBoxContainer.get_node("SpellFrame" + str(number)).get_node("SpellTexture").texture = spell.get_node("Sprite2D").texture
			$HBoxContainer/VBoxContainer/SpellSlots/HBoxContainer.get_node("SpellFrame" + str(number)).get_node("SpellTexture").scale = spell.get_node("Sprite2D").scale
			$HBoxContainer/VBoxContainer/SpellSlots/HBoxContainer.get_node("SpellFrame" + str(number)).set_cooldown(spell.cooldown_timer.wait_time)
		number += 1


func start_spell_cooldown():
	$HBoxContainer/VBoxContainer/SpellSlots/HBoxContainer.get_node("SpellFrame" + str(current_selected_spell)).start_cooldown()


func select_spell():
	$HBoxContainer/VBoxContainer/SpellSlots/HBoxContainer.get_node("SpellFrame" + str(previous_selected_spell)).get_node("Selected").visible = false
	$HBoxContainer/VBoxContainer/SpellSlots/HBoxContainer.get_node("SpellFrame" + str(current_selected_spell)).get_node("Selected").visible = true
	previous_selected_spell = current_selected_spell


func start_dash_cooldown(value):
	$HBoxContainer/VBoxContainer/Dash/HBoxContainer/DashIcon.set_cooldown(value)
	$HBoxContainer/VBoxContainer/Dash/HBoxContainer/DashIcon.start_cooldown()


func _ready():
	set_hearts(health)
	set_coins(coins)
	set_bombs(bombs)
	set_spells(spell_slots)
	
	PlayerStats.health_changed.connect(_on_health_changed)
	PlayerStats.coins_changed.connect(_on_coins_changed)
	PlayerStats.bombs_changed.connect(_on_bombs_changed)
	PlayerStats.max_health_changed.connect(_on_max_health_changed)
	PlayerStats.spell_equipped.connect(_on_spell_equipped)
	PlayerStats.coin_deposited.connect(_on_coin_deposited)


func _on_health_changed(value):
	set_hearts(value)

func _on_coins_changed(value):
	set_coins(value)
	
func _on_bombs_changed(value):
	set_bombs(value)

func _on_max_health_changed(value):
	max_hearts = value
	set_hearts(PlayerStats.player_health)

func _on_spell_equipped():
	set_spells(PlayerStats.slots)

func _on_coin_deposited(value):
	set_coins(value)
