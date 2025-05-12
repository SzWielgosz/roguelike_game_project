extends State
@onready var idle_timer: Timer = $IdleTimer
var waited: bool = false


func enter():
	super.enter()
	owner.set_physics_process(false)
	animated_sprite.play("idle")
	waited = false
	idle_timer.start()


func transition():
	if waited:
		get_parent().change_state("Jump")


func _on_idle_timer_timeout():
	waited = true
