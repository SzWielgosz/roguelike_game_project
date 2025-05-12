extends State
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var bow_animated_sprite_2d: AnimatedSprite2D = $"../../Bow/AnimatedSprite2D"
@onready var shoot_delay_timer: Timer = $ShootDelayTimer
@onready var draw_timer: Timer = $DrawTimer
@onready var drawn_timer: Timer = $DrawnTimer
@onready var projectiles_node: Node = $Projectiles
@onready var marker_2d: Marker2D = $"../../Bow/Marker2D"
@onready var bow: Node2D = $"../../Bow"
@export var arrow_scene: PackedScene
var player_in_sight: bool = false
var active: bool = false


func enter():
	draw()
	active = true
	super.enter()


func exit():
	active = false
	bow_animated_sprite_2d.play("idle")
	bow.global_rotation = 0
	super.exit()


func transition():
	if player_in_sight:
		bow.look_at(player.global_position)
		if player.global_position.x < owner.global_position.x:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
	else:
		get_parent().change_state("Idle")


func draw():
	animated_sprite_2d.play("draw")
	bow_animated_sprite_2d.play("draw")
	draw_timer.start()


func shoot():
	if active:
		var direction = (player.global_position - owner.global_position).normalized()
		var arrow_instance = arrow_scene.instantiate()
		projectiles_node.add_child(arrow_instance)
		arrow_instance.global_position = marker_2d.global_position
		arrow_instance.global_rotation = (player.global_position - owner.global_position).angle()
		arrow_instance.direction = direction
		shoot_delay_timer.start()


func _on_detection_range_body_entered(body):
	player_in_sight = true


func _on_detection_range_body_exited(body):
	player_in_sight = false


func _on_draw_timer_timeout():
	if active:
		bow_animated_sprite_2d.play("drawn")
		drawn_timer.start()



func _on_shoot_delay_timer_timeout():
	if active:
		draw()


func _on_drawn_timer_timeout():
	if active:
		bow_animated_sprite_2d.play("idle")
		shoot()
