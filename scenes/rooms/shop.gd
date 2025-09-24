extends CanvasLayer
@onready var item_list: ItemList = $Control/NinePatchRect/ItemList
@onready var deposited_coins_counter: Label = $Control/NinePatchRect/DepositedCoinsCounter
var deposited_money = PlayerStats.coins_deposited
var shop_table: Dictionary = ShopStats.shop_table
var index_to_key: Dictionary = {} #Poniewaz wszystko jest w parametrze text


func _ready():
	var i = 0
	for key in shop_table.keys():
		var item_name = key + "  Price: " + str(shop_table[key]["price"]) + " coins"
		item_list.add_item(item_name, shop_table[key]["icon"])
		index_to_key[i] = key
		
		if shop_table[key].get("unlocked", false):
			item_list.set_item_disabled(i, true)
		
		i += 1
		
	change_counter(deposited_money)


func _on_item_list_item_selected(index):
	purchase_item(index)


func purchase_item(index):
	var key = index_to_key.get(index)
	if key == null:
		return
	var item = shop_table[key]
	if deposited_money >= item["price"]:
		deposited_money -= item["price"]
		item_list.set_item_disabled(index, true)
		shop_table[key]["unlocked"] = true
		TreasureStats.add_unlocked_items_to_drop_table()
		change_counter(deposited_money)
		print("Item unlocked: " + key)
	else:
		print("Not enough coins")
	print("Shop stats: ", ShopStats.shop_table)


func apply_saved_shop_state(shop_table: Dictionary):
	for key in shop_table.keys():
		if shop_table.has(key):
			shop_table[key]["unlocked"] = shop_table[key].get("unlocked", false)


func change_counter(amount: int):
	deposited_coins_counter.text = str(amount)


func open_shop():
	visible = true


func close_shop():
	visible = false


func _on_close_button_pressed():
	close_shop()
