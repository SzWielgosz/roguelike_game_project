extends Node
var lesser_fireball_scroll_scene = preload("res://scenes/spells/lesser_fireball/lesser_fireball_scroll.tscn")
var fireball_scroll_scene = preload("res://scenes/spells/fireball/fireball_scroll.tscn")
var fire_boomerang_scroll_scene = preload("res://scenes/spells/fire_boomerang/fire_boomerang_scroll.tscn")
var damage_modifier: float = 1.0
var player: CharacterBody2D = null
var player_health: float = 3.0
var player_max_health: float = 3.0
var player_max_hearts: int = 9
var player_coins: int = 0
var player_bombs: int = 3
var slots: Array = []
var selected_slot: int = 0
var coin_lost_this_frame: bool = false

signal health_changed(value)
signal max_health_changed(value)
signal coins_changed(value)
signal bombs_changed(value)
signal slot_changed(value)
signal cooldown_started(spell_name, slot)


func _ready():
	var lesser_fireball = lesser_fireball_scroll_scene.instantiate()
	var fireball = fireball_scroll_scene.instantiate()
	var fire_boomerang = fire_boomerang_scroll_scene.instantiate()
	add_child(lesser_fireball)
	add_child(fireball)
	add_child(fire_boomerang)
	slots = [lesser_fireball, fireball, fire_boomerang]


func _process(_delta):
	coin_lost_this_frame = false
	

func set_spells():
	pass


func set_player(p):
	player = p


func get_selected_spell():
	return slots[selected_slot]
	

func get_spell_names():
	var spells = []
	for spell in slots:
		spells.append(spell.name)
	return spells


func switch_slot(slot_index: int):
	if slot_index >= 0 and slot_index < slots.size():
		selected_slot = slot_index


func _input(event):
	if event.is_action_pressed("select_first_spell"):
		switch_slot(0)
	elif event.is_action_pressed("select_second_spell"):
		switch_slot(1)
	elif event.is_action_pressed("select_third_spell"):
		switch_slot(2)


func add_coins(amount: int):
	player_coins += amount
	coins_changed.emit(player_coins)


func substract_coins(amount: int):
	player_coins -= amount
	coins_changed.emit(player_coins)


func add_bomb(amount: int):
	player_bombs += amount
	bombs_changed.emit(player_bombs)


func substract_bomb(amount: int):
	player_bombs -= amount
	bombs_changed.emit(player_bombs)


func set_health(value: float):
	player_health = clamp(value, 0, player_max_health)
	health_changed.emit(player_health)


func increase_max_health(amount: float):
	var new_max = clamp(player_max_health + amount, 3, player_max_hearts)
	if new_max > player_max_health:
		player_max_health = new_max
		player_health = clamp(player_health + amount, 0, player_max_health)
		max_health_changed.emit(player_max_health)
		set_health(player_health)


func get_heart_count():
	return int(player_health)


func get_half_heart_count():
	return 1 if player_health - int(player_health) >= 0.5 else 0


func get_empty_heart_count():
	return player_max_hearts - get_heart_count() - get_half_heart_count()


func reset():
	player_health = 3.0
	player_max_health = 3.0
	player_coins = 0
	player_bombs = 3
