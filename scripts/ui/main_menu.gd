extends CanvasLayer
@onready var main_buttons = $NinePatchRect/MainButtons
@onready var settings = $NinePatchRect/Settings
@onready var credits = $NinePatchRect/Credits
@onready var fullscreen_setting = $NinePatchRect/Settings/VBoxContainer/FullscreenSetting
@onready var vsync_setting = $NinePatchRect/Settings/VBoxContainer/VSyncSetting
@onready var master_volume_slider = $NinePatchRect/Settings/VBoxContainer/HBoxContainer/VBoxContainer2/MasterVolumeSlider
@onready var music_volume_slider = $NinePatchRect/Settings/VBoxContainer/HBoxContainer/VBoxContainer2/MusicVolumeSlider
@onready var sfx_volume_slider = $NinePatchRect/Settings/VBoxContainer/HBoxContainer/VBoxContainer2/SFXVolumeSlider


func _ready():
	var video_settings = ConfigFileHandler.load_video_settings()
	fullscreen_setting.button_pressed = video_settings.fullscreen
	vsync_setting.button_pressed = video_settings.vsync
	var audio_settings = ConfigFileHandler.load_audio_settings()
	master_volume_slider.value = min(audio_settings.master_volume, 1.0) * 100
	music_volume_slider.value = min(audio_settings.music_volume, 1.0) * 100
	sfx_volume_slider.value = min(audio_settings.sfx_volume, 1.0) * 100


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/rooms/lobby.tscn")


func _on_settings_back_pressed():
	main_buttons.visible = true
	settings.visible = false


func _on_settings_button_pressed():
	main_buttons.visible = false
	settings.visible = true


func _on_credits_button_pressed():
	main_buttons.visible = false
	credits.visible = true


func _on_credits_back_pressed():
	main_buttons.visible = true
	credits.visible = false


func _on_quit_button_pressed():
	get_tree().quit()


func _on_v_sync_setting_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		ConfigFileHandler.save_video_settings("v-sync", toggled_on)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		ConfigFileHandler.save_video_settings("v-sync", toggled_on)


func _on_fullscreen_setting_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		ConfigFileHandler.save_video_settings("fullscreen", toggled_on)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		ConfigFileHandler.save_video_settings("fullscreen", toggled_on)


func _on_master_volume_slider_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_settings("master_volume", master_volume_slider.value / 100)


func _on_music_volume_slider_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_settings("music_volume", music_volume_slider.value / 100)


func _on_sfx_volume_slider_drag_ended(value_changed):
	if value_changed:
		ConfigFileHandler.save_audio_settings("sfx_volume", sfx_volume_slider.value / 100)
