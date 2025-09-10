extends Node2D

signal died
@export var max_health : float
@export var damage_reduction : float = 0
var health : float 
@export var damage_dealt : float = 10000


func _ready() -> void:
	health = max_health

func take_damage(damage : float) -> void:
	health -= (damage * (1 - damage_reduction))
	$"..".damaged()
	if health <= 0:
		EventBus.minion_died.emit(damage_dealt)
		died.emit()
