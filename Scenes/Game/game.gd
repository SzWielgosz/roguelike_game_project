extends Node2D
@onready var generator = $Generator
# Called when the node enters the scene tree for the first time.
func _ready():
	generator.create_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
