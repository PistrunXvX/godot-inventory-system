extends Node

signal items_changed(indexes)

var cols: int = 6
var rows: int = 6
var slots: int = cols * rows
var items: Array = []

func _ready():
	for i in range(slots):
		items.append({})
	
	items[0] = Global.get_item_by_key("orange")
	items[1] = Global.get_item_by_key("orange")
	items[2] = Global.get_item_by_key("orange")
	items[3] = Global.get_item_by_key("potion")
	items[4] = Global.get_item_by_key("potion")
	items[5] = Global.get_item_by_key("sword")

func set_item(index, item):
	var previos_item = items[index]
	items[index] = item
	items_changed.emit([index])
	return previos_item

func remove_item(index):
	var previos_item = items[index].duplicate()
	items[index].clear()
	items_changed.emit([index])
	return previos_item

func set_item_quantity(index, amount):
	items[index].quantity += amount
	if items[index].quantity <= 0:
		remove_item(index)
	else:
		items_changed.emit([index])
