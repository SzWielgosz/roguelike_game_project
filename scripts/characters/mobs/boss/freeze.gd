extends State
@onready var boss = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var player_entered: bool


func enter():
	super.enter()
	player_entered = false
	animated_sprite_2d.play("idle")


func transition():
	if player_entered:
		get_parent().change_state("Idle")


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_entered = true
