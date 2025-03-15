extends Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var marker = $Marker2D
var opened: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D/CollisionShape2D.disabled = true


func open_door():
	animation_player.play("door_opening")
	if timer.is_inside_tree():
		timer.start()


func close_door():
	animation_player.play("door_closing")
	if timer.is_inside_tree():
		timer.start()


func _on_timer_timeout():
	if opened:
		opened = false
		$".".frame = 0
	else:
		opened = true
		$".".frame = 6


func _on_door_area_body_entered(body):
	if body.is_in_group("player"):
		body.global_position = marker.global_position
