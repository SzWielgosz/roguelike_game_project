extends Node
class_name PlayerHealth

@export var knockback_strength: Vector2 = Vector2(0, 0)
@export var immortality: bool = false
@onready var player = get_parent()
var velocity = Vector2.ZERO


signal player_died

func _ready():
	PlayerStats.health_changed.connect(_on_health_changed)


func take_damage(value, knockback = Vector2(0, 0)) -> float:
	if immortality:
		print("Player is immortal")
		return PlayerStats.player_health
		
	PlayerStats.set_health(PlayerStats.player_health - value)
	print("Player took damage! HP left:", PlayerStats.player_health)
	apply_knockback(knockback)

	
	set_immortality(true)
	return PlayerStats.player_health


func apply_knockback(force: Vector2):
	player.knockback += force


func set_immortality(value: bool):
	immortality = value
	if immortality:
		player.set_collision_layer_value(3, false)
		player.set_collision_mask_value(2, false)
		$"../ImmortalityTimer".start()
		$"../ImmortalityBlinkTimer".start()
	else:
		player.set_collision_layer_value(3, true)
		player.set_collision_mask_value(2, true)
		$"../ImmortalityBlinkTimer".stop()
		$"../AnimatedSprite2D".visible = true
		$"../Arm/Sprite2D".visible = true


func _on_immortality_timer_timeout():
	set_immortality(false)


func _on_health_changed(health_value):
	if health_value <= 0:
		print("Player died")
		player.velocity = Vector2.ZERO
		player.knockback = Vector2.ZERO
		player.set_collision_layer_value(3, false)
		player.set_collision_mask_value(2, false)
		$"../ImmortalityBlinkTimer".stop()
		$"../AnimatedSprite2D".visible = true
		$"../Arm".visible = false
		$"../Arm".set_process(false)
		$"../Arm".set_process_input(false)
		player_died.emit()


func _on_immortality_blink_timer_timeout():
	if PlayerStats.player_health <= 0:
		$"../ImmortalityBlinkTimer".stop()
		return
	$"../AnimatedSprite2D".visible = not $"../AnimatedSprite2D".visible
	$"../Arm/Sprite2D".visible = not $"../Arm/Sprite2D".visible


func _on_hit_box_body_entered(body):
	if body.is_in_group("mobs"):
		take_damage(body.get_node("Health").damage)
