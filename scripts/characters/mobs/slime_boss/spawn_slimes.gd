extends State
@onready var mobs_container: Node = $MobsCointainer
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var wait_timer: Timer = $WaitTimer
@onready var spawn_points: Node2D = $"../../MobSpawnPoints"
@export var slime_scene: PackedScene
var waited: bool = false
var jump_count: int = 0


func enter():
	super.enter()
	jump_count = 0
	owner.set_physics_process(false)
	animated_sprite_2d.play("jump")
	wait_timer.start()

func spawn_slimes():
	for spawn_point in spawn_points.get_children():
		var slime_instance = slime_scene.instantiate()
		get_tree().current_scene.add_child(slime_instance)
		slime_instance.global_position = spawn_point.global_position

func _on_wait_timer_timeout():
	spawn_slimes()
	get_parent().change_state("Dash")

