extends State
@onready var wait_timer: Timer = $WaitTimer
@onready var projectiles_container = $ProjectilesContainer
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@export var goo_ball_scene: PackedScene
var waited: bool = false


func enter():
	super.enter()
	owner.set_physics_process(false)
	animated_sprite_2d.play("jump")


func _on_animated_sprite_2d_animation_finished():
	shoot_goo_balls()
	get_parent().change_state("Idle")


func shoot_goo_balls():
	var directions = [
		Vector2(1, 1).normalized(),
		Vector2(-1, -1).normalized(),
		Vector2(1, -1).normalized(),
		Vector2(-1, 1).normalized()
	]
	for direction in directions:
		var goo_ball_instance = goo_ball_scene.instantiate()
		projectiles_container.add_child(goo_ball_instance)
		goo_ball_instance.global_position = owner.global_position
		goo_ball_instance.direction = direction

	animated_sprite.play("idle")
