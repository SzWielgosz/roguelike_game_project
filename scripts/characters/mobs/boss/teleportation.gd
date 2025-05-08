extends State
@onready var teleportation_points: Array[Marker2D] = $"../..".teleportation_points
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var boss: CharacterBody2D = $"../.."
@onready var timer: Timer = $Timer
var can_transition: bool


func enter():
	super.enter()
	can_transition = false
	#boss.set_physics_process(true)
	#animated_sprite.play("teleportation")
	teleport()




func transition():
	if can_transition:
		get_parent().change_state("ShootFireballs")


func teleport():
	while true:
		var tp_idx = randi_range(0, teleportation_points.size() - 1)
		var teleportation_point = teleportation_points[tp_idx]
		if teleportation_point.global_position != boss.global_position:
			boss.global_position = teleportation_point.global_position
			timer.start()
			break
	


func _on_timer_timeout():
	can_transition = true
