extends Node
class_name PlayerHealth

@export var knockback_strength: Vector2 = Vector2(0, 0)
@export var immortality: bool = false
@onready var health: float = 2.0
@onready var max_health: float = 3.0
@onready var player = get_parent()
var velocity = Vector2.ZERO
signal health_changed(health_value: float)
signal player_died


func take_damage(value, knockback) -> float:
	if immortality:
		print("Player is immortal")
		return health
		
	health -= value
	print("Player took damage! HP left:", health)
	apply_knockback(knockback)
	health_changed.emit(health)
	
	set_immortality(true)
	return health


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
	health = health_value
	if health <= 0:
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
	if health <= 0:
		$"../ImmortalityBlinkTimer".stop()
		return
	$"../AnimatedSprite2D".visible = not $"../AnimatedSprite2D".visible
	$"../Arm/Sprite2D".visible = not $"../Arm/Sprite2D".visible
