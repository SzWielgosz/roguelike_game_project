extends Node2D
@onready var placed_timer = $PlacedTimer
@onready var explosion_timer = $ExplosionTimer
@onready var animation_player = $AnimationPlayer
@export var mob_damage = 50
@export var player_damage = 0.5


func _ready():
	animation_player.play("placed")
	placed_timer.start()


func _on_explosion_radius_body_entered(body):
	if body.is_in_group("player"):
		var health = body.get_node("PlayerHealth")
		health.take_damage(player_damage)
		
	if body.is_in_group("mobs"):
		var health = body.get_node("Health")
		health.take_damage(mob_damage)


func _on_placed_timer_timeout():
	animation_player.play("explosion")
	explosion_timer.start()


func _on_explosion_timer_timeout():
	queue_free()
