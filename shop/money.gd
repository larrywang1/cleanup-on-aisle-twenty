extends TextureRect

@export var label : Label

func _ready() -> void:
	EventBus.money_changed.connect(change_money)

func change_money() -> void:
	label.text = str(RunManager.money)
