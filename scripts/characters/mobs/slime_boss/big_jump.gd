extends State
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var big_jump_timer: Timer = $BigJumpTimer
@onready var in_air_timer: Timer = $InAirTimer
@onready var landing_timer: Timer = $LandingTimer
@onready var container: Node = $Container
@onready var hitbox_collision_shape: CollisionShape2D = $"../../HitBox/CollisionShape2D"
@onready var character_body_collision_shape: CollisionShape2D = $"../../CollisionShape2D"
@export var goo_ball_scene: PackedScene
@export var goo_drop_scene: PackedScene
@export var num_drops: int
@export var num_projectiles: int
@export var speed: int = 80
var can_transition: bool = false
var waited: bool = false
var jump_count: int = 0
var is_in_air: bool = false


func enter():
	super.enter()
	owner.set_physics_process(true)
	can_transition = false
	animated_sprite_2d.play("big_jump")
	big_jump_timer.start()

func exit():
	super.exit()

func transition():
	if is_in_air:
		owner.velocity = (player.global_position - owner.global_position).normalized() * speed
	if can_transition:
		get_parent().change_state("Idle")

func land():
	var spawn_area = owner.area_2d
	var shape = spawn_area.get_node("CollisionShape2D").shape
	var extents = shape.extents
	var area_size = shape.get_size()
	var origin = spawn_area.global_position - extents
	
	for i in range(num_drops):
		var random_pos = Vector2(
			randf_range(-extents.x, extents.x),
			randf_range(-extents.y, extents.y)
		)
		
		var goo_instance = goo_drop_scene.instantiate()
		goo_instance.scale = Vector2(3, 3)
		goo_instance.global_position = random_pos + spawn_area.global_position
		container.add_child(goo_instance)
		
	for i in range(num_projectiles):
		var angle = (TAU / num_projectiles) * i
		var direction = Vector2.RIGHT.rotated(angle)
		var goo_ball_instance = goo_ball_scene.instantiate()
		goo_ball_instance.scale = Vector2(5, 5)
		container.add_child(goo_ball_instance)
		goo_ball_instance.global_position = owner.global_position
		goo_ball_instance.direction = direction


func _on_big_jump_timer_timeout():
	is_in_air = true
	animated_sprite_2d.play("in_air")
	hitbox_collision_shape.disabled = true
	#character_body_collision_shape.disabled = true
	in_air_timer.start()


func _on_in_air_timer_timeout():
	owner.velocity = Vector2.ZERO
	is_in_air = false
	animated_sprite_2d.play("landing")
	landing_timer.start()


func _on_landing_timer_timeout():
	land()
	hitbox_collision_shape.disabled = false
	#character_body_collision_shape.disabled = false
	can_transition = true
	
