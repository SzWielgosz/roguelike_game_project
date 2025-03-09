extends State
@onready var detection_range = $"../../DetectionRange"
var idle_timer: Timer = Timer.new()

func enter():
	super.enter()
	owner.set_physics_process(false)
	queue_free()
