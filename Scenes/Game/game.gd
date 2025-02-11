extends Node2D
@onready var generator = $RoomGenerator
var paused_game = false
# Called when the node enters the scene tree for the first time.
func _ready():
	generator.create_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("pause"):
		if paused_game:
			get_tree().paused = false
		get_tree().paused = true
