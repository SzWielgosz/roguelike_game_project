extends Node
class_name PlayerHealth

@export var knockback_strength: Vector2 = Vector2(0, 0)
@export var immortality: bool = false
@onready var player = get_parent()
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var hitbox: Area2D = $"../HitBox"
@onready var arm: Node2D = $"../Arm"
@onready var arm_sprite: Sprite2D = $"../Arm/Sprite2D"
@onready var immortality_timer: Timer = $"../ImmortalityTimer"
@onready var immortality_blink_timer: Timer = $"../ImmortalityBlinkTimer"
var velocity = Vector2.ZERO
var immortality_type: String = "" 

signal player_died

func _ready():
	PlayerStats.health_changed.connect(_on_health_changed)


func take_damage(value: float, knockback: Vector2 = Vector2.ZERO) -> float:
	if immortality:
		print("Player is immortal")
		return PlayerStats.player_health
	
	PlayerStats.set_health(PlayerStats.player_health - value)
	print("Player took damage! HP left:", PlayerStats.player_health)

	apply_knockback(knockback)

	if immortality_type != "dash":
		set_immortality(true, "hit")
		
	return PlayerStats.player_health


func apply_knockback(force: Vector2):
	var final_force = force * knockback_strength
	player.knockback += final_force


func set_immortality(value: bool, type: String = ""):
	immortality = value
	immortality_type = type if value else ""

	player.set_collision_layer_value(3, not value)
	player.set_collision_mask_value(2, not value)

	if value:
		if type == "hit":
			immortality_timer.start()
			immortality_blink_timer.start()
	else:
		immortality_blink_timer.stop()
		animated_sprite_2d.visible = true
		arm_sprite.visible = true


func _on_immortality_timer_timeout():
	if immortality_type == "hit":
		set_immortality(false)


func _on_health_changed(health_value):
	if health_value <= 0:
		die()


func die():
	print("Player died")
	player.velocity = Vector2.ZERO
	player.knockback = Vector2.ZERO

	player.set_collision_layer_value(3, false)
	player.set_collision_layer_value(4, false)
	player.set_collision_mask_value(2, false)

	immortality_blink_timer.stop()
	animated_sprite_2d.visible = true
	arm.visible = false
	arm.set_process(false)
	arm.set_process_input(false)

	player_died.emit()


func _on_immortality_blink_timer_timeout():
	if PlayerStats.player_health <= 0:
		immortality_blink_timer.stop()
		return

	animated_sprite_2d.visible = not animated_sprite_2d.visible
	arm_sprite.visible = not arm_sprite.visible


func _on_hit_box_body_entered(body):
	if body.is_in_group("mobs") and not immortality:
		var health_component = body.get_node_or_null("Health")
		if health_component:
			take_damage(health_component.damage)


func _on_dash_timer_timeout():
	set_immortality(false)


func _on_player_dash_active():
	set_immortality(true, "dash")
