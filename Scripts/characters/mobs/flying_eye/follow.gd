extends State
@onready var follow_timer: Timer = $FollowTimer

var player_exited: bool = false:
	set(value):
		player_exited = value


func enter():
	super.enter()
	owner.set_physics_process(true)


func exit():
	super.exit()
	owner.set_physics_process(false)


func transition():
	if player and !player_exited and follow_timer.is_stopped():
		follow_timer.start()
	if player_exited:
		get_parent().change_state("Idle")
	owner.direction = (player.global_position - owner.global_position).normalized()



func _on_detection_range_area_exited(_area):
	player_exited = true


func _on_detection_range_area_entered(_area):
	player_exited = false


func _on_follow_timer_timeout():
	if player and !player_exited:
		owner.direction = (player.global_position - owner.global_position).normalized()

