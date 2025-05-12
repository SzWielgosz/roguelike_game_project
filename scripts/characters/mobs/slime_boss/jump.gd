extends State
@onready var projectiles_container = $ProjectilesContainer
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var wait_timer: Timer = $WaitTimer
@export var goo_ball_scene: PackedScene
@export var jumps: int
var waited: bool = false
var jump_count: int = 0


func enter():
	super.enter()
	jump_count = 0
	owner.set_physics_process(false)
	animated_sprite_2d.play("jump")
	wait_timer.start()

func exit():
	super.exit()
	jump_count = 0

func shoot_goo_balls():
	var number_of_projectiles = 12
	for i in range(number_of_projectiles):
		var angle = (TAU / number_of_projectiles) * i
		var direction = Vector2.RIGHT.rotated(angle)
		var goo_ball_instance = goo_ball_scene.instantiate()
		goo_ball_instance.scale = Vector2(5, 5)
		projectiles_container.add_child(goo_ball_instance)
		goo_ball_instance.global_position = owner.global_position
		goo_ball_instance.direction = direction

func _on_wait_timer_timeout():
	if jump_count > jumps:
		get_parent().change_state("SpawnSlimes")
	else:
		shoot_goo_balls()
		jump_count += 1
		animated_sprite_2d.play("jump")
		wait_timer.start()
