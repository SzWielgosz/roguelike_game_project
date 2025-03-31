extends Node
var lesser_fireball_scroll_scene = preload("res://scenes/spells/lesser_fireball/lesser_fireball_scroll.tscn")
var fireball_scroll_scene = preload("res://scenes/spells/fireball/fireball_scroll.tscn")
var fire_boomerang_scroll_scene = preload("res://scenes/spells/fire_boomerang/fire_boomerang_scroll.tscn")
var player_health: float = 3.0
var player_max_health: float = 3.0
var player_max_hearts: int = 10
var player_gold: int = 0
var player_bombs: int = 3
var slots: Array = []
var selected_slot: int = 0
var gold_lost_this_frame: bool = false

signal health_changed(value)
signal gold_changed(value)
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
	gold_lost_this_frame = false


func get_selected_spell():
	return slots[selected_slot]


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


func add_gold(amount: int):
	player_gold += amount
	gold_changed.emit(player_gold)


func substract_gold(amount: int):
	player_gold -= amount
	gold_changed.emit(player_gold)


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
	player_max_health = clamp(player_max_health + amount, 3, player_max_hearts)
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
	player_gold = 0
	player_bombs = 3
