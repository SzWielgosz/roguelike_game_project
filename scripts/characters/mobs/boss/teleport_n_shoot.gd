extends State
@onready var boss: CharacterBody2D = $"../.."
@onready var delay_timer: Timer = $DelayTimer
@onready var state_timer: Timer = $StateTimer
@export var fireball_scene: PackedScene
@onready var teleportation_points: Array[Marker2D] = $"../..".teleportation_points
var can_transition: bool


func enter():
	super.enter()
	can_transition = false
	delay_timer.start()
	state_timer.start()


func exit():
	super.exit()
	delay_timer.stop()
	state_timer.stop()


func transition():
	if can_transition:
		get_parent().change_state("Idle")


func teleport():
	var rand_idx = randi_range(0, teleportation_points.size() - 1)
	var tp_point = teleportation_points[rand_idx]
	boss.global_position = tp_point.global_position


func shoot_fireball():
	var direction = (player.global_position - boss.global_position).normalized()
	var fireball_node = fireball_scene.instantiate()
	get_tree().current_scene.add_child(fireball_node)
	fireball_node.global_position = boss.global_position
	fireball_node.set_direction(direction)


func _on_delay_timer_timeout():
	teleport()
	shoot_fireball()
	delay_timer.start()


func _on_state_timer_timeout():
	can_transition = true


