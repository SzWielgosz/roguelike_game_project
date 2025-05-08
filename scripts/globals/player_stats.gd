extends Node
var lesser_fireball_scroll_scene = preload("res://scenes/spells/lesser_fireball/lesser_fireball_scroll.tscn")
var damage_modifier: float = 1.0
var player: CharacterBody2D = null
var player_health: float = 3.0
var player_max_health: float = 3.0
var player_max_hearts: int = 9
var player_coins: int = 0
var player_bombs: int = 3
var slots: Array = [null, null, null]
var selected_slot: int = 0
var coin_lost_this_frame: bool = false
var coins_deposited: int = 0

signal health_changed(value)
signal max_health_changed(value)
signal coins_changed(value)
signal bombs_changed(value)
signal slot_changed(value)
signal cooldown_started(spell_name, slot)
signal spell_equipped
signal coin_deposited(coins_left)


func _ready():
	var lesser_fireball = lesser_fireball_scroll_scene.instantiate()
	equip_spell(lesser_fireball, Vector2(0, 0), 0)


func _process(_delta):
	coin_lost_this_frame = false
	

func equip_spell(input_scroll: SpellScroll, input_position: Vector2, slot=selected_slot):
	var spell_scroll = get_selected_spell() # pobieram aktualnego spella
	print("Input position: ", input_position)
	print("Aktualny spell w slocie: ", spell_scroll)
	print("Pobierany spell: ", input_scroll)
	if spell_scroll: # jezeli istnieje
		spell_scroll.drop(input_position, get_tree().current_scene) # dropnij do aktualnej sceny z pozycją inputa
	if input_scroll.get_parent(): # jezeli podnoszony spell ma rodzica, to reparent
		input_scroll.reparent(self)
	else: # jak nie ma rodzica, to add_child
		add_child(input_scroll)
	slots[slot] = input_scroll # ustaw input spella na selected slota 
	spell_equipped.emit()


func set_player(p):
	player = p


func get_selected_spell():
	return slots[selected_slot]


func get_spell_names():
	var spells = []
	for spell in slots:
		if spell != null:
			spells.append(spell.scroll_name)
	return spells


func get_current_spell_scrolls():
	var dict = {}
	var idx = 0
	for spell in slots:
		if spell:
			dict[idx] = {
				"spell_name": spell.spell_name,
				"scroll_name": spell.scroll_name
			}
		else:
			dict[idx] = null
		idx += 1
	return dict


func switch_slot(slot_index: int):
	if slot_index >= 0 and slot_index < slots.size():
		selected_slot = slot_index
		print("Selected slot: ", selected_slot)


func clear_slots():
	slots = [null, null, null]


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
	clear_slots()
	var lesser_fireball = lesser_fireball_scroll_scene.instantiate()
	equip_spell(lesser_fireball, Vector2(0, 0), 0)
