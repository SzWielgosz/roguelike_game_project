extends State
@onready var boss = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var state_timer = $StateTimer
@onready var delay_timer = $DelayTimer
@export var laser_scene: PackedScene
@onready var teleport_point: Marker2D = $"../..".shoot_laser_point
var laser_instance
var can_transition: bool = false
var rotation_speed = 10.0


func enter():
	super.enter()
	player = get_tree().current_scene.find_child("Player")
	animated_sprite_2d.play("idle")
	boss.global_position = teleport_point.global_position
	can_transition = false
	delay_timer.start()


func exit():
	super.exit()
	laser_instance.queue_free()
	laser_instance = null
	state_timer.stop()


func transition():
	if laser_instance:
		var player_position = player.global_position - boss.global_position
		laser_instance.rotation = lerp_angle(laser_instance.rotation, player_position.angle(), rotation_speed * get_process_delta_time())
	if can_transition:
		get_parent().change_state("SpiralShooting")


func shoot_laser():
	laser_instance = laser_scene.instantiate()
	get_tree().current_scene.add_child(laser_instance)
	laser_instance.global_position = boss.global_position
	

func _on_state_timer_timeout():
	can_transition = true


func _on_delay_timer_timeout():
	shoot_laser()
	state_timer.start()
