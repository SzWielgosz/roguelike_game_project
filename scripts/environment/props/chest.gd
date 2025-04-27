extends RigidBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var dropped_items = $DroppedItems
var is_opened: bool = false


func _process(delta):
	if !is_opened:
		animated_sprite_2d.play("closed")
	else:
		animated_sprite_2d.play("opened")


func _on_open_area_2d_body_entered(body):
	if !is_opened:
		call_deferred("open_chest")
		is_opened = true


func choose_random_drop():
	var total_type_chance = 0.0
	for drop_type in DropStats.drop_table["types"]:
		total_type_chance += drop_type["chance"]

	var rand_type = GameStats.random_number_generator.randf() * total_type_chance
	var accumulated_type = 0.0

	for drop_type in DropStats.drop_table["types"]:
		accumulated_type += drop_type["chance"]
		if rand_type <= accumulated_type:
			var total_item_chance = 0.0
			for item in drop_type["items"]:
				total_item_chance += item["chance"]

			var rand_item = GameStats.random_number_generator.randf() * total_item_chance
			var accumulated_item = 0.0

			for item in drop_type["items"]:
				accumulated_item += item["chance"]
				if rand_item <= accumulated_item:
					return item
			break


func open_chest():
	var drop = choose_random_drop()
	var quantity = randi_range(drop["quantity_range"].x, drop["quantity_range"].y)
	if drop.has("scene"):
		for i in range(quantity):
			var instance = drop["scene"].instantiate()
			$DroppedItems.add_child(instance)
			instance.global_position = global_position
			var angle = GameStats.random_number_generator.randf() * TAU
			var force = GameStats.random_number_generator.randf_range(25, 50)
			var impulse = Vector2.RIGHT.rotated(angle) * force
			
			instance.apply_central_impulse(impulse)
