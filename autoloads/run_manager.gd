extends Node

var money : int = 0:
	get: return money
	set(value):
		money = value
		EventBus.money_changed.emit()

var section : int = 0
var aisle : int = 0

var player : Player

func reset() -> void:
	money = 0
	section = 0
	aisle = 0
