extends Node2D

var items : Array[Item] = []

func add_item(item_to_add : Resource):
	items.append(item_to_add)
	item_to_add.item_manager = self
	item_to_add.purchased()

func remove_item(item_to_remove : Resource):
	items.remove_at(items.find(item_to_remove))
