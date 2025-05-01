extends RigidBody2D


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		PlayerStats.damage_modifier += 0.1
		GameManager.show_item_popup.emit($Label.text)
		queue_free()
