extends State
@onready var detection_range = $"../../DetectionRange"
@onready var wander_timer = $WanderTimer
@export var wander_radius: float = 50
var hit_wall: bool = false

var player_entered: bool = false:
	set(value):
		player_entered = value
		detection_range.set_deferred("disable_mode", value)

var target_position: Vector2


func enter():
	super.enter()
	owner.set_physics_process(true)
	choose_new_target_point()
	animated_sprite.play("run")


func exit():
	super.exit()
	owner.set_physics_process(false)


func transition():
	owner.direction = target_position - owner.global_position
	
	if owner.direction.length() < 10:
		get_parent().change_state("Idle")
		
	if player_entered:
		get_parent().change_state("Follow")


func _on_detection_range_area_entered(_area):
	player_entered = true


func _on_detection_range_area_exited(_area):
	player_entered = false


func choose_new_target_point():
	var random_offset = Vector2(randf_range(-wander_radius, wander_radius), randf_range(-wander_radius, wander_radius))
	target_position = owner.global_position + random_offset


func _on_hit_box_body_entered(body):
	print("Entered: ", body)
	hit_wall = true
	wander_timer.start()


func _on_hit_box_body_exited(body):
	print("Exited: ", body)
	hit_wall = false


func _on_timer_timeout():
	if hit_wall:
		print("Trying new route")
		choose_new_target_point()
		wander_timer.start()
