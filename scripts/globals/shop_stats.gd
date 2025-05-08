extends Node
var shop_table: Dictionary = {
	"RockThrow": {
			"price": 15, 
			"icon": preload("res://assets/art/v1.1 dungeon crawler 16X16 pixel pack/heroes/mage/magic/rock_throw/rock_throw_idle.png"),
			"scene": preload("res://scenes/spells/rock_throw/rock_throw_scroll.tscn"),
			"chance": 0.2,
			"unlocked": false
		},
	"Fireball": {
			"price": 10,
			"icon": preload("res://assets/art/v1.1 dungeon crawler 16X16 pixel pack/heroes/mage/magic/fireball/fireball_animation1.png"),
			"scene": preload("res://scenes/spells/fireball/fireball_scroll.tscn"),
			"chance": 0.2,
			"unlocked": false
		},
	"FireBoomerang": {
			"price": 10,
			"icon": preload("res://assets/art/v1.1 dungeon crawler 16X16 pixel pack/heroes/mage/magic/fire_boomerang/fire_boomerang_animation1.png"),
			"scene": preload("res://scenes/spells/fire_boomerang/fire_boomerang_scroll.tscn"),
			"chance": 0.2,
			"unlocked": false
		},
}


func apply_saved_shop_state(saved_shop_table: Dictionary):
	for key in saved_shop_table.keys():
		if shop_table.has(key):
			shop_table[key]["unlocked"] = saved_shop_table[key].get("unlocked", false)
