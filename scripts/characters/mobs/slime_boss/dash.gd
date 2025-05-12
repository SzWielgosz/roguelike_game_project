extends State
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var dash_timer: Timer = $DashTimer
@onready var wait_timer: Timer = $WaitTimer
@onready var goo_spawn_timer: Timer = $GooSpawnTimer
@onready var navigation_agent_2d: NavigationAgent2D = $"../../NavigationAgent2D"
@onready var goo_container: Node = $GooContainer
@export var goo_scene: PackedScene
@export var dashes: int
var dash_count: int = 0
var dash_speed: int = 200
var dashing: bool = false
var target_velocity = Vector2.ZERO


func enter():
	super.enter()
	owner.set_physics_process(true)
	dashing = true
	wait_timer.start()

func exit():
	owner.velocity = Vector2.ZERO
	dash_count = 0
	super.exit()

func transition():
	animated_sprite.flip_h = false if owner.velocity.x > 0 else true
	if dash_count == dashes and !dashing:
		get_parent().change_state("BigJump")

func dash():
	animated_sprite_2d.play("run")
	var direction = (player.global_position - owner.global_position).normalized()
	target_velocity = direction * dash_speed
	owner.velocity = target_velocity
	dash_timer.start()

func _on_dash_timer_timeout():
	if dash_count < dashes:
		dash_count += 1
		wait_timer.start()
	else:
		dashing = false
		goo_spawn_timer.stop()

func _on_wait_timer_timeout():
	goo_spawn_timer.start()
	dash()

func _on_goo_spawn_timer_timeout():
	var goo_instance = goo_scene.instantiate()
	goo_instance.scale = Vector2(2, 2)
	goo_container.add_child(goo_instance)
	goo_instance.global_position = owner.global_position
