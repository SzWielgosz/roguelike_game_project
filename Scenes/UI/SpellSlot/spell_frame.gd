extends Control
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var label: Label = $Label
var cooldown_started: bool = false
var cooldown_value: float = 0.0

func _process(delta):
	if cooldown_started:
		label.text = str(round_to_dec(cooldown_timer.time_left, 2))
	
func set_cooldown(time):
	cooldown_timer.wait_time = time
	cooldown_value = time
	
func start_cooldown():
	label.visible = true
	cooldown_timer.start()
	cooldown_started = true

func _on_cooldown_timer_timeout():
	cooldown_started = false
	label.visible = false

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
