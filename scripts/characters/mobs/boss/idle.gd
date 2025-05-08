extends State
@onready var idle_timer: Timer = $IdleTimer
@onready var animated_sprite_2d = $"../../AnimatedSprite2D"
@onready var boss = $"../.."
var can_transition: bool


func enter():
	super.enter()
	animated_sprite_2d.play("idle")
	can_transition = false
	idle_timer.start()


func transition():
	if can_transition and $"../../../..".player_inside:
		get_parent().change_state("Teleport")


func _on_idle_timer_timeout():
	can_transition = true
