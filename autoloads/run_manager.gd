extends Node

var money : int = 0:
	get: return money
	set(value):
		money = value
		EventBus.money_changed.emit()
