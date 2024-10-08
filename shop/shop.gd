extends CanvasLayer

@export var item_slots : Array[Control]
var shop_odds : Array[int]
var total_shop_odds : int
var reroll_price : int
var reroll_price_increase : int
@export var common_items : Array[Item]
@export var rare_items : Array[Item]
@export var legendary_items : Array[Item]
@onready var item_manager : Node2D = get_tree().get_first_node_in_group("item_manager")
@export var sale_probability : float
@export var sale_value : float
@export var reroll_button : TextureButton

var last_shop_items : Array = [null, null, null, null]
var current_shop_items : Array = [null, null, null, null]

func initialize() -> void:
	reroll()
	reroll_button.label.text = reroll_button.text + str(reroll_price)

func roll_item(item_slot : Control) -> void:
	var index = item_slots.find(item_slot)
	if not item_slot.is_locked:
		var item_ : Item
		var rand_num = randi_range(1, total_shop_odds)
		if shop_odds[0] >= rand_num:
			item_ = common_items.pick_random()
		elif shop_odds[0] + shop_odds[1] >= rand_num:
			item_ = rare_items.pick_random()
		else:
			item_ = legendary_items.pick_random()
		if item_.unique:
			if item_ in item_manager.items:
				roll_item(item_slot)
				return
		#if item_ in last_shop_items or item_ in current_shop_items:
			#roll_item(item_slot)
			#return
		item_slot.is_available = true
		item_slot.lock_button.disabled = false
		item_slot.item_ = item_
		item_slot.price = item_.price
		item_slot.sale_texture.visible = false
		if randf_range(0, 1) <= sale_probability:
			item_slot.price = int(round(float(item_slot.price) * sale_value))
			item_slot.show_sale()
		item_slot.price_label.text = str(item_slot.price)
		item_slot.item_texture.texture = item_.texture
		update_buy_buttons()
	current_shop_items[index] = item_slot.item_

func reroll() -> void:
	last_shop_items = current_shop_items
	current_shop_items = [null, null, null, null]
	for item_slot in item_slots:
		roll_item(item_slot)


func reroll_button_pressed() -> void:
	reroll()
	RunManager.money -= reroll_price
	reroll_price += reroll_price_increase
	update_buy_buttons()
	reroll_button.label.text = reroll_button.text + str(reroll_price)

func purchased_item(item_slot_index : int) -> void:
	item_manager.add_item(item_slots[item_slot_index].item_)
	item_slots[item_slot_index].lock_button.button_pressed = false
	item_slots[item_slot_index].is_available = false
	item_slots[item_slot_index].is_locked = false
	item_slots[item_slot_index].lock_button.disabled = true
	RunManager.money -= item_slots[item_slot_index].price
	update_buy_buttons()
	print(item_manager.items)
	
func update_buy_buttons() -> void:
	for item_slot in item_slots:
		item_slot.buy_button.disabled = true if item_slot.price > RunManager.money or not item_slot.is_available else false
	reroll_button.disabled = true if reroll_price > RunManager.money else false

func end_shop() -> void:
	EventBus.end_shop.emit()
