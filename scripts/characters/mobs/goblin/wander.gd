extends State

@onready var navigation_agent: NavigationAgent2D = $"../../NavigationAgent2D"
@onready var detection_range = $"../../DetectionRange"
@onready var wander_timer = $WanderTimer
@export var wander_radius: float = 50

var hit_wall: bool = false

var player_entered: bool = false:
	set(value):
		player_entered = value
		detection_range.set_deferred("disable_mode", value)

func enter():
	super.enter()
	owner.set_physics_process(true)
	choose_new_target_point()
	animated_sprite.play("run")

func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	if navigation_agent.is_navigation_finished():
		get_parent().change_state("Idle")
		return

	var next_position = navigation_agent.get_next_path_position()
	var direction = owner.global_position.direction_to(next_position)
	var new_velocity = direction * owner.speed

	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)

	animated_sprite.flip_h = false if owner.velocity.x > 0 else true

	if player_entered:
		get_parent().change_state("Follow")

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2):
	owner.velocity = safe_velocity

func choose_new_target_point():
	var random_offset = Vector2(
		randf_range(-wander_radius, wander_radius),
		randf_range(-wander_radius, wander_radius)
	)
	var destination = owner.global_position + random_offset
	navigation_agent.target_position = destination

func _on_detection_range_area_entered(_area):
	player_entered = true

func _on_detection_range_area_exited(_area):
	player_entered = false

func _on_hit_box_body_entered(body):
	if !body.is_in_group("player"):
		hit_wall = true
		wander_timer.start()

func _on_hit_box_body_exited(body):
	if !body.is_in_group("player"):
		hit_wall = false

func _on_wander_timer_timeout():
	if hit_wall:
		choose_new_target_point()
		wander_timer.start()
