extends Button

@export var action_name: String
@export var key_name: String

var input_notification: String = "Press a key to bind..."
var listening: bool = false

func _ready():
	text = action_name + ": " + key_name

func _on_pressed():
	listening = true
	text = input_notification

func _input(event):
	var key_already_bound: bool = false
	if listening:
		var keybindings = ConfigFileHandler.get_keybindings()
		if event is InputEventKey or event is InputEventMouseButton:
			var event_str = ""
			if event is InputEventKey:
				event_str = OS.get_keycode_string(event.physical_keycode)
			elif event is InputEventMouseButton:
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						event_str = "Left Mouse Button"
					MOUSE_BUTTON_RIGHT:
						event_str = "Right Mouse Button"
					_: 
						event_str = "Mouse Button " + str(event.button_index)

			if event_str != "":
				key_name = event_str
				text = action_name + ": " + key_name
				listening = false

			for value in keybindings.values():
				if event_str == value:
					key_already_bound = true
					break
			if !key_already_bound:
				ConfigFileHandler.save_keybindings(action_name, event)
				ConfigFileHandler.apply_keybindings_to_input_map()

func set_input_button(action: String, key: String):
	action_name = action
	key_name = key
	text = action_name + ": " + key_name

