extends Spell
class_name ChannelSpell

@export var channel_timer: Timer
var is_channeled: bool = false # Is spell fully channeled
var is_holding: bool = false # Is player holding the button
signal channel_fail


func _ready():
	channel_timer.timeout.connect(_on_channel_complete)
	start_channeling()


func _input(event):
	if event.is_action_released("use_spell"):
		stop_channeling()


func start_channeling():
	is_holding = true
	is_channeled = false
	channel_timer.start()


func stop_channeling():
	if is_channeled:
		cast.emit()
	else:
		channel_fail.emit()
		queue_free()
		
	set_process_input(false)


func _on_channel_complete():
	is_channeled = true
