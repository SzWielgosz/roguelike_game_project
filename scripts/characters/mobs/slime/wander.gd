extends State
@onready var wander_timer = $WanderTimer
@onready var agent: NavigationAgent2D = $"../../NavigationAgent2D"
@onready var goo_container: Node = $GooContainer
@onready var goo_spawn_timer: Timer = $GooSpawnTimer
@onready var navigation_agent: NavigationAgent2D = $"../../NavigationAgent2D"
@export var goo_scene: PackedScene
@export var wander_radius: float = 200
var hit_wall: bool = false
var target_position: Vector2


func enter():
	super.enter()
	owner.set_physics_process(true)
	choose_new_target_point()
	animated_sprite.play("run")
	goo_spawn_timer.start()


func exit():
	super.exit()
	goo_spawn_timer.stop()
	owner.set_physics_process(false)


func transition():
	if navigation_agent.is_navigation_finished():
		get_parent().change_state("Jump")
		return

	var next_position = navigation_agent.get_next_path_position()
	var direction = owner.global_position.direction_to(next_position)
	var new_velocity = direction * owner.speed

	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)

	animated_sprite.flip_h = false if owner.velocity.x > 0 else true


func choose_new_target_point():
	var random_offset = Vector2(
		randf_range(-wander_radius, wander_radius),
		randf_range(-wander_radius, wander_radius)
	)
	var destination = owner.global_position + random_offset
	navigation_agent.target_position = destination


func _on_hit_box_body_entered(body):
	if !body.is_in_group("player"):
		hit_wall = true
		wander_timer.start()


func _on_hit_box_body_exited(body):
	if !body.is_in_group("player"):
		hit_wall = false


func _on_wander_timer_timeout():
	if hit_wall:
		print("Trying new route")
		choose_new_target_point()
		wander_timer.start()


func _on_goo_spawn_timer_timeout():
	var goo_instance = goo_scene.instantiate()
	goo_container.add_child(goo_instance)
	goo_instance.global_position = owner.global_position


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	owner.velocity = safe_velocity
