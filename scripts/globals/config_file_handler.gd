extends Node
var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"


func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybindings", "move_left", "A")
		config.set_value("keybindings", "move_right", "D")
		config.set_value("keybindings", "move_up", "W")
		config.set_value("keybindings", "move_down", "S")
		config.set_value("keybindings", "select_first_spell", "1")
		config.set_value("keybindings", "select_second_spell", "2")
		config.set_value("keybindings", "select_third_spell", "3")
		config.set_value("keybindings", "use_bomb", "G")
		config.set_value("keybindings", "use_spell", "Left Mouse Button")
		config.set_value("keybindings", "interact", "E")
		config.set_value("keybindings", "reset", "R")
		config.set_value("keybindings", "dash", "Space")
		config.set_value("keybindings", "pause_menu", "Escape")

		config.set_value("video", "fullscreen", false)
		config.set_value("video", "vsync", true)

		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "music_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		
		config.set_value("show_message", "thank_you", true)
		

		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)


func save_video_settings(key: String, value):
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)


func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings


func save_audio_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)


func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings


func save_show_message_setting(value: bool):
	config.set_value("show_message", "thank_you", value)
	config.save(SETTINGS_FILE_PATH)


func load_show_message_setting():
	var value = config.get_value("show_message", "thank_you")
	return value
