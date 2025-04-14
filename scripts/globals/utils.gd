extends Node

func get_child_or_null(parent: Node, number: int):
	if number >= 0 and number < parent.get_child_count():
		return parent.get_child(number)
	return null


func format_time(total_seconds: float) -> String:
	var t = int(total_seconds)
	var hours = t / 3600
	var minutes = (t % 3600) / 60

	if hours > 0:
		return "%d:%02d" % [hours, minutes]
	else:
		return "%d:%02d" % [0, minutes]
