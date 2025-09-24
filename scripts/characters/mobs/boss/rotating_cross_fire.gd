extends State
@onready var middle_point: Marker2D = $"../../../../MiddlePoint"
@onready var boss: CharacterBody2D = $"../.."
@onready var delay_timer: Timer = $DelayTimer
@onready var state_timer: Timer = $StateTimer
@export var fireball_scene: PackedScene
var can_transition: bool
var first_angle: int = 0
var second_angle: int = 90
var third_angle: int = 180
var fourth_angle: int = 270


func enter():
	super.enter()
	boss.global_position = middle_point.global_position
	delay_timer.start()
	state_timer.start()
	can_transition = false


func exit():
	super.exit()
	delay_timer.stop()
	state_timer.stop()


func transition():
	if can_transition:
		get_parent().change_state("TeleportNShoot")
	
 
func _on_delay_timer_timeout():
	shoot_fireball()
	delay_timer.start()


func _on_state_timer_timeout():
	can_transition = true


func shoot_fireball():
	var first_fireball_node = fireball_scene.instantiate()
	var second_fireball_node = fireball_scene.instantiate()
	var third_fireball_node = fireball_scene.instantiate()
	var fourth_fireball_node = fireball_scene.instantiate()
	
	var first_direction = Vector2.RIGHT.rotated(deg_to_rad(first_angle))
	var second_direction = Vector2.RIGHT.rotated(deg_to_rad(second_angle))
	var third_direction = Vector2.RIGHT.rotated(deg_to_rad(third_angle))
	var fourth_direction = Vector2.RIGHT.rotated(deg_to_rad(fourth_angle))
	
	first_fireball_node.set_direction(first_direction)
	second_fireball_node.set_direction(second_direction)
	third_fireball_node.set_direction(third_direction)
	fourth_fireball_node.set_direction(fourth_direction)
	
	get_tree().current_scene.add_child(first_fireball_node)
	get_tree().current_scene.add_child(second_fireball_node)
	get_tree().current_scene.add_child(third_fireball_node)
	get_tree().current_scene.add_child(fourth_fireball_node)
	
	first_fireball_node.global_position = boss.global_position
	second_fireball_node.global_position = boss.global_position
	third_fireball_node.global_position = boss.global_position
	fourth_fireball_node.global_position = boss.global_position
	
	first_angle += 10
	second_angle += 10
	third_angle += 10
	fourth_angle += 10
	first_angle %= 360
	second_angle %= 360
	third_angle %= 360
	fourth_angle %= 360
