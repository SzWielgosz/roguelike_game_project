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
	if player and !player_exited and follow_timer.is_stopped():
		follow_timer.start()
	if player_exited:
		get_parent().change_state("Idle")
		
	var current_agent_position = owner.global_position
	var next_path_position = navigation_agent.get_next_path_position()
	
	var distance_to_player = current_agent_position.distance_to(player.global_position)
	
	navigation_agent.avoidance_enabled = true if distance_to_player >= 30 else false

	var new_direction = current_agent_position.direction_to(next_path_position)
	
	var new_velocity = new_direction * owner.speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
		
	animated_sprite.flip_h = false if owner.velocity.x > 0 else true

func _on_detection_range_area_exited(_area):
	player_exited = true


func _on_detection_range_area_entered(_area):
	player_exited = false


func _on_follow_timer_timeout() -> void:
	if player and !player_exited:
		navigation_agent.target_position = player.global_position
	if navigation_agent.is_navigation_finished():
		return


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	owner.velocity = safe_velocity
