extends Node2D
@onready var ray: RayCast2D = $RayCast2D
@onready var laser_start: Sprite2D = $LaserStart
@onready var laser_middle: Sprite2D = $LaserMiddle
@onready var laser_end: Sprite2D = $LaserEnd
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var channeling_timer: Timer = $ChannelingTimer
@export var max_length: int
@export var laser_speed: int
var channeling_done: bool = false
var current_length: int = 16


func _ready():
	animated_sprite_2d.play("channeling")
	channeling_timer.start()


func _physics_process(delta):
	if channeling_done:
		if ray.is_colliding() and ray.get_collider().is_in_group("player"):
			ray.get_collider().get_node("PlayerHealth").take_damage(1)
		if current_length < max_length:
			current_length += delta * laser_speed
			current_length = min(current_length, max_length)

		ray.target_position = Vector2(current_length, 0)
		update_laser()


func update_laser():
	ray.force_raycast_update()
	var hit_position: Vector2
	if ray.is_colliding():
		hit_position = ray.get_collision_point()
	else:
		hit_position = global_position + ray.target_position
	var local_hit = to_local(hit_position)
	var laser_length = local_hit.length()

	var start_width = laser_start.texture.get_width() / 4
	var middle_width = laser_middle.texture.get_width() / 4
	var end_width = laser_end.texture.get_width() / 4
	
	
	laser_start.position = Vector2(8, 0)
	
	var middle_length = laser_length - start_width - end_width
	laser_middle.position = Vector2(((start_width + middle_length) / 2) + 8, 0)
	laser_middle.scale.x = (middle_length / middle_width)
	
	laser_end.position = Vector2(start_width + middle_length + 8, 0)



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "cast":
		animation_player.play("cast")


func _on_channeling_timer_timeout():
	channeling_done = true
	animation_player.play("cast")
	animated_sprite_2d.visible = false
	laser_start.visible = true
	laser_middle.visible = true
	laser_end.visible = true
