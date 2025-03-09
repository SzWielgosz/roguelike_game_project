extends State
@onready var detection_range = $"../../DetectionRange"
@onready var idle_timer: Timer = $IdleTimer

var player_entered: bool = false:
	set(value):
		player_entered = value
		detection_range.set_deferred("disable_mode", value)
var waited: bool = false


func enter():
	super.enter()
	owner.set_physics_process(false)
	animated_sprite.play("flying")
	waited = false
	idle_timer.start()


func transition():
	if player_entered:
		get_parent().change_state("Follow")
	elif !player_entered and waited:
		get_parent().change_state("Wander")


func _on_detection_range_area_entered(_area):
	player_entered = true


func _on_detection_range_area_exited(_area):
	player_entered = false


func _on_idle_timer_timeout():
	waited = true
