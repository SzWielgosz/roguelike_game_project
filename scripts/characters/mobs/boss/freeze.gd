extends State
@onready var boss = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"


func enter():
	super.enter()
	animated_sprite_2d.play("idle")


func transition():
	if $"../..".player_in_sight:
		get_parent().change_state("Idle")
