extends Node
var drop_table = {
	"LesserFireball":{
		"scene": preload("res://scenes/spells/lesser_fireball/lesser_fireball_scroll.tscn"),
		"chance": 0.1
	}
}

func add_unlocked_items_to_drop_table():
	var shop_table = ShopStats.shop_table
	for item in shop_table.keys():
		if shop_table[item]["unlocked"] == true:
			drop_table[item] = {
				"scene": shop_table[item]["scene"],
				"chance": shop_table[item]["chance"]
			}
	print(drop_table)

