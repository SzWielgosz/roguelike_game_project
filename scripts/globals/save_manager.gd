extends Node
const SAVE_SLOTS: int = 3
const AUTOSAVE_PATH: String = "user://autosave.tres"
var current_save_slot: int = 1
var save_data: SaveData = null
var can_save: bool = true
var dungeon_to_load: bool = false

signal load_game
signal game_save_result(success: bool)


func _process(delta):
	if GameStats.player_clearing_room:
		can_save = false
	else:
		can_save = true


func get_save_data():
	return save_data


func get_slot_path(slot: int):
	return "user://save_slot_%d.tres" % slot


func save_to_slot(slot: int):
	var path = get_slot_path(current_save_slot)
	save_to_path(path)


func autosave():
	save_to_path(AUTOSAVE_PATH)


func save_to_path(path: String):
	if save_data == null:
		print("No saves detected")
		return

	var err = ResourceSaver.save(save_data, path)
	if err != OK:
		print("Error during saving: ", err)
	else:
		print("Game saved: ", path)


func save_game():
	save_data = SaveData.new()
	
	save_data.player_in_dungeon = GameStats.player_in_dungeon
	save_data.player_position = PlayerStats.player.global_position
	save_data.player_spell_slots = PlayerStats.get_spell_names()
	save_data.total_time_played = GameStats.total_time_played
	save_data.time_played = GameStats.time_played
	save_data.mobs_killed = GameStats.mobs_killed
	save_data.coins_collected = GameStats.coins_collected
	save_data.bombs_used = GameStats.bombs_used
	save_data.spells_casted = GameStats.spells_casted
	save_data.selected_spell = PlayerStats.selected_slot
	save_data.player_health = PlayerStats.player_health
	save_data.player_bombs = PlayerStats.player_bombs
	save_data.player_coins = PlayerStats.player_gold
	save_data.rng_seed = GameStats.random_number_generator.seed
	
	var rooms_dict = {}
	if save_data.player_in_dungeon:
		var rooms = get_tree().root.get_node("Game").get_node("Rooms")
		for room in rooms.get_children():
			var room_status
			var room_area = room.get_node("RoomArea")
			if room_area.room_cleared or room_area.type == 2: # <- START
				room_status = "cleared"
			else:
				room_status = "not_cleared"
			
			#var room_layout = room.get_node("RoomLayout").get_child(0).get_node_or_null("Destroyables")
			var room_layout = Utils.get_child_or_null(room.get_node("RoomLayout"), 0)
			var room_data = {}
			room_data["status"] = room_status
			var destroyables = {}
			var items = {}
			if room_layout:
				var layout_destroyables = room_layout.get_node("NavigationRegion2D").get_node_or_null("Destroyables")
				if layout_destroyables:
					for group in layout_destroyables.get_children():
						var group_destroyable_statues = {}
						for destroyable in group.get_children():
							group_destroyable_statues[destroyable.name] = { "is_destroyed": destroyable.is_destroyed }
						#destroyables_statuses[destroyable.name] = destroyable.is_destroyed
						destroyables[group.name] = group_destroyable_statues
					room_data["destroyables"] = destroyables
				var layout_items = room_layout.get_node("NavigationRegion2D").get_node_or_null("Items")
				if layout_items:
					for group in layout_items.get_children():
						var group_items = {}
						for item in group.get_children():
							group_items[item.name] = { "picked_up": false }
						items[group.name] = group_items
					room_data["items"] = items
			else:
				room_data["destroyables"] = destroyables
				room_data["items"] = items
			rooms_dict[room.name] = room_data

	save_data.dungeon_rooms = rooms_dict

	save_to_path(get_slot_path(current_save_slot))


func apply_loaded_save():
	if save_data == null:
		print("No data to load")
		return
	
	dungeon_to_load = save_data.player_in_dungeon
	GameStats.player_in_dungeon = save_data.player_in_dungeon
	GameStats.time_played = save_data.time_played
	GameStats.total_time_played = save_data.total_time_played
	GameStats.mobs_killed = save_data.mobs_killed
	GameStats.coins_collected = save_data.coins_collected
	GameStats.bombs_used = save_data.bombs_used
	GameStats.spells_casted = save_data.spells_casted
	GameStats.random_number_generator.seed = save_data.rng_seed
	
	#PlayerStats.set_spell_names(save_data.player_spell_slots)
	PlayerStats.selected_slot = save_data.selected_spell
	PlayerStats.player_health = save_data.player_health
	PlayerStats.player_bombs = save_data.player_bombs
	PlayerStats.player_gold = save_data.player_coins
	
	if save_data.player_in_dungeon:
		get_tree().change_scene_to_file("res://scenes/main/game.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/rooms/lobby.tscn")



func load_game_from_slot(slot: int):
	var path = get_slot_path(slot)
	current_save_slot = slot
	load_from_path(path)


func load_autosave():
	load_from_path(AUTOSAVE_PATH)


func load_from_path(path):
	if not ResourceLoader.exists(path):
		print("Save doesn't exist: ", path)
		return
	
	save_data = ResourceLoader.load(path)
	print("save_data loaded: ",  save_data)
	return save_data


func get_total_time_played_from_slot(slot: int):
	var path = get_slot_path(slot)
	if not ResourceLoader.exists(path):
		print("Save doesn't exist: ", path)
		return
	
	var tmp = ResourceLoader.load(path)
	return tmp.total_time_played


func create_new_save():
	save_data = SaveData.new()
