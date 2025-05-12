extends CanvasLayer
@onready var main_buttons: Control = $NinePatchRect/MainButtons
@onready var settings: Control = $NinePatchRect/Settings
@onready var credits: Control = $NinePatchRect/Credits
@onready var fullscreen_setting: CheckButton = $NinePatchRect/Settings/VBoxContainer/FullscreenSetting
@onready var vsync_setting: CheckButton = $NinePatchRect/Settings/VBoxContainer/VSyncSetting
@onready var master_volume_slider: HSlider = $NinePatchRect/Settings/VBoxContainer/HBoxContainer/VBoxContainer2/MasterVolumeSlider
@onready var music_volume_slider: HSlider = $NinePatchRect/Settings/VBoxContainer/HBoxContainer/VBoxContainer2/MusicVolumeSlider
@onready var sfx_volume_slider: HSlider = $NinePatchRect/Settings/VBoxContainer/HBoxContainer/VBoxContainer2/SFXVolumeSlider
@onready var save_slots: Control  = $NinePatchRect/SaveSlots
@onready var thank_you_popup: Control  = $NinePatchRect/ThankYouPopup
@onready var do_not_show_again_checkbox: CheckBox = $NinePatchRect/ThankYouPopup/VBoxContainer/DoNotShowAgainCheckBox
@onready var first_slot: Button = $NinePatchRect/SaveSlots/VBoxContainer/HBoxContainer/VBoxContainer/FirstSlot
@onready var second_slot: Button = $NinePatchRect/SaveSlots/VBoxContainer/HBoxContainer/VBoxContainer2/SecondSlot
@onready var third_slot: Button = $NinePatchRect/SaveSlots/VBoxContainer/HBoxContainer/VBoxContainer3/ThirdSlot
@onready var delete_first_slot: Button = $NinePatchRect/SaveSlots/VBoxContainer/HBoxContainer/VBoxContainer/DeleteFirstSlot
@onready var delete_second_slot: Button = $NinePatchRect/SaveSlots/VBoxContainer/HBoxContainer/VBoxContainer2/DeleteSecondSlot
@onready var delete_third_slot: Button = $NinePatchRect/SaveSlots/VBoxContainer/HBoxContainer/VBoxContainer3/DeleteThirdSlot
@onready var delete_save_enable_button: Button = $NinePatchRect/SaveSlots/VBoxContainer/DeleteSaveEnableButton
@onready var delete_save_disable_button: Button = $NinePatchRect/SaveSlots/VBoxContainer/DeleteSaveDisableButton
@onready var key_bindings: Control = $NinePatchRect/KeyBindings
@onready var key_bindings_setting: VBoxContainer = $NinePatchRect/KeyBindings/VBoxContainer/ScrollContainer/KeyBindingsSetting
@onready var how_to_play: Control = $NinePatchRect/HowToPlay


func _ready():
	var video_settings = ConfigFileHandler.load_video_settings()
	var keybinding_settings = ConfigFileHandler.apply_keybindings_to_input_map()
	fullscreen_setting.button_pressed = video_settings.fullscreen
	vsync_setting.button_pressed = video_settings.vsync
	var audio_settings = ConfigFileHandler.load_audio_settings()
	master_volume_slider.value = min(audio_settings.master_volume, 1.0) * 100
	music_volume_slider.value = min(audio_settings.music_volume, 1.0) * 100
	sfx_volume_slider.value = min(audio_settings.sfx_volume, 1.0) * 100

	if !ConfigFileHandler.load_show_message_setting():
		thank_you_popup.visible = false
	
	set_save_slots()
	set_keybinding_buttons()


func set_save_slots():
	var first_slot_time = SaveManager.get_total_time_played_from_slot(1)
	var second_slot_time = SaveManager.get_total_time_played_from_slot(2)
	var third_slot_time = SaveManager.get_total_time_played_from_slot(3)
	
	if first_slot_time != null:
		first_slot.text = "First slot\ntime played: " + Utils.format_time(first_slot_time)
	else:
		first_slot.text = "First slot\n(no save)"

	if second_slot_time != null:
		second_slot.text = "Second slot\ntime played: " + Utils.format_time(second_slot_time)
	else:
		second_slot.text = "Second slot\n(no save)"

	if third_slot_time != null:
		third_slot.text = "Third slot\ntime played: " + Utils.format_time(third_slot_time)
	else:
		third_slot.text = "Third slot\n(no save)"


func _on_play_button_pressed():
	save_slots.visible = true
	main_buttons.visible = false


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


func _on_back_button_pressed():
	save_slots.visible = false
	main_buttons.visible = true


func _on_first_slot_pressed():
	SaveManager.load_game_from_slot(1)
	if SaveManager.get_save_data():
		SaveManager.apply_loaded_save()
	else:
		get_tree().change_scene_to_file("res://scenes/rooms/lobby.tscn")


func _on_second_slot_pressed():
	SaveManager.load_game_from_slot(2)
	if SaveManager.get_save_data():
		SaveManager.apply_loaded_save()
	else:
		get_tree().change_scene_to_file("res://scenes/rooms/lobby.tscn")


func _on_third_slot_pressed():
	SaveManager.load_game_from_slot(3)
	if SaveManager.get_save_data():
		SaveManager.apply_loaded_save()
	else:
		get_tree().change_scene_to_file("res://scenes/rooms/lobby.tscn")


func _on_do_not_show_again_check_box_toggled(toggled_on):
	if toggled_on:
		ConfigFileHandler.save_show_message_setting(false)
	else:
		ConfigFileHandler.save_show_message_setting(true)


func _on_close_popup_button_pressed():
	thank_you_popup.visible = false


func _on_delete_save_enable_button_pressed():
	delete_first_slot.visible = true
	delete_second_slot.visible = true
	delete_third_slot.visible = true
	delete_save_enable_button.visible = false
	delete_save_disable_button.visible = true


func _on_delete_save_disable_pressed():
	delete_first_slot.visible = false
	delete_second_slot.visible = false
	delete_third_slot.visible = false
	delete_save_enable_button.visible = true
	delete_save_disable_button.visible = false


func _on_delete_first_slot_pressed():
	SaveManager.delete_save_slot(1)
	set_save_slots()


func _on_delete_second_slot_pressed():
	SaveManager.delete_save_slot(2)
	set_save_slots()


func _on_delete_third_slot_pressed():
	SaveManager.delete_save_slot(3)
	set_save_slots()


func _on_key_bindings_button_pressed():
	key_bindings.visible = true
	settings.visible = false


func _on_key_bindings_back_button_pressed():
	settings.visible = true
	key_bindings.visible = false


func set_keybinding_buttons():
	var keybindings = ConfigFileHandler.config.get_section_keys("keybindings")
	var keybinding_children = key_bindings_setting.get_children()
	var idx = 0
	for action in keybindings:
		var key = ConfigFileHandler.config.get_value("keybindings", action)
		var button = keybinding_children[idx]
		button.set_input_button(action, key)
		idx += 1


func _on_reset_key_bindings_button_pressed():
	ConfigFileHandler.set_default_keybindings()
	set_keybinding_buttons()


func _on_how_to_play_button_pressed():
	how_to_play.visible = true
	main_buttons.visible = false


func _on_how_to_play_back_button_pressed():
	how_to_play.visible = false
	main_buttons.visible = true
