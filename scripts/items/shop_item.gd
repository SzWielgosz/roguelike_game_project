extends Area2D
class_name ShopItem
@export var price: int
@export var item_scene: PackedScene


func _ready():
	body_entered.connect(_on_body_entered)


func purchase():
	if PlayerStats.player_coins >= price:
		var item_instance = item_scene.instantiate()
		add_child(item_instance)
		item_instance.global_position = global_position
		PlayerStats.player_coins -= price
		PlayerStats.coins_changed.emit(PlayerStats.player_coins)


func _on_body_entered(body):
	call_deferred("purchase")
