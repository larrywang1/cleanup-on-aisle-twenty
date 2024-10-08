extends TextureButton

@export var label : Label
@export var item_slot : int 
@onready var shop = $"../.."

func _on_button_down() -> void:
	label.position.y += 4

func _on_button_up() -> void:
	label.position.y -= 4
	shop.purchased_item(item_slot)
