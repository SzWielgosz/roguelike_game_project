extends Node2D
@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready():
	timer.start()
	var idx = randi_range(0, sprite_2d.hframes - 1)
	sprite_2d.set_frame(idx)

func _on_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if body.get_node("PlayerHealth") != null:
			var damage = body.get_node("PlayerHealth").take_damage(0.5)
