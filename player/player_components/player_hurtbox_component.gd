extends Area2D

@export var health_component : Node2D

func take_damage() -> void:
	health_component.take_damage()
