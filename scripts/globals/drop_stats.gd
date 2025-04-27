extends Node
var drop_table: Dictionary = {
	"types": [
		{
			"name": "basic_drops",
			"chance": 0.7,
			"items": [
				{
					"name": "heart",
					"scene": preload("res://scenes/items/heart.tscn"),
					"chance": 0.2,
					"quantity_range": Vector2i(1, 2)
				},
				{
					"name": "half_heart",
					"scene": preload("res://scenes/items/half_heart.tscn"),
					"chance": 0.25,
					"quantity_range": Vector2i(1, 2)
				},
				{
					"name": "coin",
					"scene": preload("res://scenes/items/coin.tscn"),
					"chance": 0.3,
					"quantity_range": Vector2i(1, 5)
				},
				{
					"name": "bomb",
					"scene": preload("res://scenes/items/bomb_collectible.tscn"),
					"chance": 0.15,
					"quantity_range": Vector2i(1, 2)
				}
			]
		},
		{
			"name": "effect_drops",
			"chance": 0.3,
			"items": [
				{
					"name": "health_potion",
					"scene": preload("res://scenes/items/health_potion.tscn"),
					"chance": 0.5,
					"quantity_range": Vector2i(1, 1)
				},
				{
					"name": "damage_potion",
					"scene": preload("res://scenes/items/damage_potion.tscn"),
					"chance": 0.5,
					"quantity_range": Vector2i(1, 1)
				}
			]
		}
	]
}
