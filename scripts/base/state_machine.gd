extends Node2D
class_name StateMachine

var current_state: State
var previous_state: State


func _ready():
	current_state = get_child(0) as State
	previous_state = current_state
	current_state.enter()


func change_state(state_name: String):
	if current_state != null and current_state.name == state_name:
		return

	var new_state = find_child(state_name)
	if new_state == null or not new_state is State:
		return

	if current_state != null:
		current_state.exit()
		previous_state = current_state

	current_state = new_state
	current_state.enter()


func _on_health_dead():
	change_state("Death")
