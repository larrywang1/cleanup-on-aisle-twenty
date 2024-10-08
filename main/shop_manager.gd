extends Node2D

var shop := preload("res://shop/shop.tscn")
var shop_instance
@onready var main : Node2D = get_tree().get_first_node_in_group("main")
var shop_odds : Array[int] = [50, 10, 1]
var total_shop_odds : int = 61
var reroll_price : int = 10
var reroll_price_increase : int = 1
var money_per_boss : int = 200
var money_increase_per_boss : int = 25

func _ready() -> void:
	EventBus.cutscene_finished.connect(start_shop)
	EventBus.end_shop.connect(end_shop)
	shop_instance = shop.instantiate()

func start_shop() -> void:
	RunManager.money += money_per_boss
	money_per_boss += money_increase_per_boss
	
	shop_instance.shop_odds = shop_odds
	shop_instance.total_shop_odds = total_shop_odds
	shop_instance.reroll_price = reroll_price
	shop_instance.reroll_price_increase = reroll_price_increase
	main.add_child(shop_instance)
	shop_instance.initialize()
	EventBus.money_changed.emit()

func end_shop() -> void:
	main.remove_child(shop_instance)
	get_tree().paused = false
