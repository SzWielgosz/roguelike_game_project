extends State
@onready var navigation_agent: NavigationAgent2D = $"../../NavigationAgent2D"
@onready var follow_timer: Timer = $FollowTimer

var player_exited: bool = false:
	set(value):
		player_exited = value


func setup_seeker():
	await get_tree().physics_frame
	if player:
		navigation_agent.target_position = player.global_position


func enter():
	super.enter()
	owner.set_physics_process(true)
	animated_sprite.play("run")
	setup_seeker()


func exit():
	super.exit()
	owner.set_physics_process(false)


func transition():
	var current_agent_position = owner.global_position
	var next_path_position = navigation_agent.get_next_path_position()
	if player and !player_exited and follow_timer.is_stopped():
		follow_timer.start()
	if player_exited:
		get_parent().change_state("Idle")
	owner.direction = current_agent_position.direction_to(next_path_position)


func _on_detection_range_area_exited(area):
	player_exited = true


func _on_detection_range_area_entered(area):
	player_exited = false


func _on_follow_timer_timeout() -> void:
	if player and !player_exited:
		navigation_agent.target_position = player.global_position
	if navigation_agent.is_navigation_finished():
		return
