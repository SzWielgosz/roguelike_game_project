extends State
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var staff_animated_sprite_2d: AnimatedSprite2D = $"../../Staff/AnimatedSprite2D"
@onready var delay_timer: Timer = $DelayTimer
@onready var charge_timer: Timer = $ChargeTimer
@onready var projectiles_node: Node = $Projectiles
@onready var marker_2d: Marker2D = $"../../Staff/Marker2D"
@onready var staff: Node2D = $"../../Staff"
@export var bullet_scene: PackedScene
@export var shots: int
var shots_taken: int = 0
var player_in_sight: bool = false
var active: bool = false


func enter():
	shots_taken = 0
	charge()
	active = true
	super.enter()


func exit():
	active = false
	staff_animated_sprite_2d.play("idle")
	staff.global_rotation = 0
	super.exit()


func transition():
	if shots_taken < shots:
		staff.look_at(player.global_position)
		if player.global_position.x < owner.global_position.x:
			animated_sprite_2d.flip_h = true
			staff_animated_sprite_2d.flip_v = true
		else:
			animated_sprite_2d.flip_h = false
			staff_animated_sprite_2d.flip_v = true
	else:
		get_parent().change_state("Shoot")


func charge():
	staff_animated_sprite_2d.play("charge")
	charge_timer.start()


func shoot():
	if active:
		var number_of_projectiles = 3
		var spread_angle_degrees = 30
		var half_spread = spread_angle_degrees / 2

		var base_direction = (player.global_position - owner.global_position).normalized()
		var base_angle = base_direction.angle()

		for i in range(number_of_projectiles):
			var offset_angle = deg_to_rad(-half_spread + i * (spread_angle_degrees / (number_of_projectiles - 1)))
			var direction = Vector2.RIGHT.rotated(base_angle + offset_angle)
			var bullet_instance = bullet_scene.instantiate()
			projectiles_node.add_child(bullet_instance)
			bullet_instance.global_position = marker_2d.global_position
			bullet_instance.global_rotation = direction.angle()
			bullet_instance.direction = direction

		delay_timer.start()
		shots_taken += 1



func _on_delay_timer_timeout():
	if active:
		shoot()


func _on_charge_timer_timeout():
	if active:
		staff_animated_sprite_2d.play("charged")
		shoot()
		delay_timer.start()
