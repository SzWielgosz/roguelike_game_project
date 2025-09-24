extends Node2D
@export var bullet_scene: PackedScene
@export var target: CharacterBody2D
@onready var wait_timer: Timer = $WaitTimer
@onready var shoot_delay_timer: Timer = $ShootDelayTimer
@onready var projectiles_container: Node = $Projectiles
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var knockback
var diagonal_shot: bool = false


func _ready():
	wait_timer.start()
	if animated_sprite_2d.material != null and !animated_sprite_2d.material.resource_local_to_scene:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
		animated_sprite_2d.material.resource_local_to_scene = true

func _on_wait_timer_timeout():
	shoot_delay_timer.start()

func _on_shoot_delay_timer_timeout():
	shoot()

func shoot():
	var directions = []

	if diagonal_shot:
		directions = [
			Vector2(-1, -1).normalized(),
			Vector2(1, -1).normalized(),
			Vector2(-1, 1).normalized(),
			Vector2(1, 1).normalized()
		]
	else:
		directions = [
			Vector2.UP,
			Vector2.DOWN,
			Vector2.LEFT,
			Vector2.RIGHT
		]

	for direction in directions:
		var projectile_instance = bullet_scene.instantiate()
		projectile_instance.scale = Vector2(0.5, 0.5)
		projectiles_container.add_child(projectile_instance)
		projectile_instance.global_position = global_position
		projectile_instance.direction = direction

	diagonal_shot = !diagonal_shot


func _on_health_took_damage():
	var mat = animated_sprite_2d.material
	mat.set("shader_parameter/flash_strength", 1.0)
	await get_tree().create_timer(0.1).timeout
	mat.set("shader_parameter/flash_strength", 0.0)


func _on_health_dead():
	animated_sprite_2d.play("death")


func _on_animated_sprite_2d_animation_finished():
	queue_free()
