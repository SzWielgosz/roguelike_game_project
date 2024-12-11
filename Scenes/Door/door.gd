extends Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
var opened: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D/CollisionShape2D.disabled = true

func open_door():
	animation_player.play("door_opening")
	z_index = 1
	timer.start()
	
func close_door():
	animation_player.play("door_closing")
	z_index = 0
	timer.start()
	
func _on_timer_timeout():
	if opened:
		opened = false
		$".".frame = 0
	else:
		opened = true
		$".".frame = 6
		
