extends CanvasLayer
@onready var are_you_sure_lobby = $NinePatchRect/AreYouSureLobby
@onready var are_you_sure_main_menu = $NinePatchRect/AreYouSureMainMenu
@onready var are_you_sure_quit = $NinePatchRect/AreYouSureQuit
@onready var back_to_lobby_button = $NinePatchRect/VBoxContainer/BackToLobby
@onready var settings = $NinePatchRect/Settings
@onready var fullscreen_setting = $NinePatchRect/Settings/VBoxContainer/FullscreenSetting
@onready var vsync_setting = $NinePatchRect/Settings/VBoxContainer/VSyncSetting
@onready var master_volume_slider = $NinePatchRect/Settings/VBoxContainer/MasterVolumeSlider
@onready var music_volume_slider = $NinePatchRect/Settings/VBoxContainer/MusicVolumeSlider
@onready var sfx_volume_slider = $NinePatchRect/Settings/VBoxContainer/SFXVolumeSlider



func _ready():
	var video_settings = ConfigFileHandler.load_video_settings()
	fullscreen_setting.button_pressed = video_settings.fullscreen
	vsync_setting.button_pressed = video_settings.vsync
	var audio_settings = ConfigFileHandler.load_audio_settings()
	master_volume_slider.value = min(audio_settings.master_volume, 1.0) * 100
	music_volume_slider.value = min(audio_settings.music_volume, 1.0) * 100
	sfx_volume_slider.value = min(audio_settings.sfx_volume, 1.0) * 100
	
	if get_tree().root.has_node("Lobby"):
		back_to_lobby_button.visible = false


func clear_menu():
	are_you_sure_lobby.visible = false
	are_you_sure_main_menu.visible = false
	are_you_sure_quit.visible = false
	settings.visible = false


func resume():
	get_tree().paused = false


func pause():
	get_tree().paused = true


func return_to_lobby():
	PlayerStats.clear_slots()
	get_tree().change_scene_to_file("res://scenes/rooms/lobby.tscn")


func return_to_main_menu():
	PlayerStats.clear_slots()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func quit():
	get_tree().quit()


func _input(event):
	if event.is_action_pressed("pause_menu") and !get_tree().paused:
		pause()
		visible = true
	elif event.is_action_pressed("pause_menu") and get_tree().paused:
		resume()
		clear_menu()
		visible = false


func _on_resume_pressed():
	resume()
	visible = false


func _on_settings_pressed():
	settings.visible = true


func _on_quit_pressed():
	are_you_sure_quit.visible = true


func _on_back_to_lobby_pressed():
	are_you_sure_lobby.visible = true


func _on_main_menu_pressed():
	are_you_sure_main_menu.visible = true


func _on_yes_lobby_pressed():
	resume()
	GameStats.reset()
	PlayerStats.reset()
	return_to_lobby()


func _on_no_lobby_pressed():
	are_you_sure_lobby.visible = false


func _on_yes_main_menu_pressed():
	resume()
	return_to_main_menu()


func _on_no_main_menu_pressed():
	are_you_sure_main_menu.visible = false


func _on_yes_quit_pressed():
	quit()


func _on_no_quit_pressed():
	are_you_sure_quit.visible = false


func _on_fullscreen_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		ConfigFileHandler.save_video_settings("fullscreen", toggled_on)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		ConfigFileHandler.save_video_settings("fullscreen", toggled_on)


func _on_v_sync_setting_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		ConfigFileHandler.save_video_settings("v-sync", toggled_on)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		ConfigFileHandler.save_video_settings("v-sync", toggled_on)


func _on_back_settings_pressed():
	settings.visible = false


func _on_master_volume_slider_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_settings("master_volume", master_volume_slider.value / 100)


func _on_music_volume_slider_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_settings("music_volume", music_volume_slider.value / 100)


func _on_sfx_volume_slider_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_settings("sfx_volume", sfx_volume_slider.value / 100)
