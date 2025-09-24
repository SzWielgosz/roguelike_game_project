extends State
@onready var mobs_container: Node = $MobsContainer
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var wait_timer: Timer = $WaitTimer
@onready var staff_animated_sprite_2d: AnimatedSprite2D = $"../../Staff/AnimatedSprite2D"
@onready var charge_timer: Timer = $ChargeTimer
@export var tree_turret_scene: PackedScene
@export var turret_count: int
var waited: bool = false
var jump_count: int = 0


func enter():
	super.enter()
	jump_count = 0
	owner.set_physics_process(false)
	wait_timer.start()

func spawn_turrets():
	var spawn_area = owner.area_2d
	var shape = spawn_area.get_node("CollisionShape2D").shape
	var extents = shape.extents
	var area_size = shape.get_size()
	var origin = spawn_area.global_position - extents
	
	for i in range(turret_count):
		var random_pos = Vector2(
			randf_range(-extents.x, extents.x),
			randf_range(-extents.y, extents.y)
		)
		
		var tree_turret_instance = tree_turret_scene.instantiate()
		tree_turret_instance.global_position = random_pos + spawn_area.global_position
		mobs_container.add_child(tree_turret_instance)


func _on_wait_timer_timeout():
	staff_animated_sprite_2d.play("charge")
	charge_timer.start()


func _on_charge_timer_timeout():
	spawn_turrets()
	get_parent().change_state("Idle")
