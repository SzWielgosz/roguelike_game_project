extends State
@onready var boss: CharacterBody2D = $"../.."
@onready var teleportation_points: Node2D = $"../../../../TeleportationPoints"
@onready var delay_timer: Timer = $DelayTimer
@onready var state_timer: Timer = $StateTimer
@export var fireball_scene: PackedScene
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
	var tp_children = teleportation_points.get_child_count() - 1
	var rand_idx = randi_range(0, tp_children)
	var tp_child = teleportation_points.get_child(rand_idx)
	boss.global_position = tp_child.global_position


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


