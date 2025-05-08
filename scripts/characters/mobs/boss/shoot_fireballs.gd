extends State
@onready var boss = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var delay_timer = $DelayTimer
@onready var state_timer = $StateTimer
@export var fireball_scene: PackedScene
var state_ended: bool 


func enter():
	super.enter()
	player = get_tree().current_scene.find_child("Player")
	animated_sprite_2d.play("idle")
	state_ended = false
	delay_timer.start()
	state_timer.start()


func exit():
	super.exit()
	delay_timer.stop()
	state_timer.stop()


func transition():
	if state_ended:
		get_parent().change_state("SpawnFlyingEyes")


func shoot_fireball():
	var direction = (player.global_position - boss.global_position).normalized()
	var fireball_node = fireball_scene.instantiate()
	get_tree().current_scene.add_child(fireball_node)
	fireball_node.set_direction(direction)
	fireball_node.global_position = boss.global_position


func _on_delay_timer_timeout():
	shoot_fireball()
	delay_timer.start()


func _on_state_timer_timeout():
	state_ended = true
