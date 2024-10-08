extends TextureButton

@export var label : Label
const text = "Reroll : "
@onready var shop := $".."

func _on_button_down() -> void:
	label.position.y += 4

func _on_button_up() -> void:
	label.position.y -= 4
	shop.reroll_button_pressed()
