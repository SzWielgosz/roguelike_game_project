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


func find_number_in_text(text: String):
	var regex = RegEx.new()
	regex.compile("\\d+")
	var first_number_found = regex.search(text)
	if first_number_found:
		var number_found = int(first_number_found.get_string())
		return number_found
	return null


func find_numbers_in_text(text: String):
	var regex = RegEx.new()
	regex.compile("\\d+")
	var all_numbers_found = regex.search_all(text)
	for number in all_numbers_found:
		var number_found = int(number.get_string())
	return all_numbers_found
