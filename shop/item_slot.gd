extends Control

@export var price_label : Label
@export var item_texture : TextureRect
@export var sale_texture : TextureRect
@export var buy_button : TextureButton
@export var lock_button : TextureButton
var item_ : Item
var price : int
var is_available : bool = true
var is_locked : bool = false

func lock(is_on : bool) -> void:
	if is_on and is_available:
		is_locked = true
	else:
		is_locked = false

func show_sale() -> void:
	sale_texture.visible = true
