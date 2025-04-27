extends RigidBody2D


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		PlayerStats.increase_max_health(1)
		queue_free()
	GameManager.show_item_popup.emit($Label.text)
