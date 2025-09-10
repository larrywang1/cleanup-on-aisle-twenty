extends Area2D

@export var health_component : Node2D

func _ready() -> void:
	EventBus.player_hit.connect(take_damage)

func take_damage() -> void:
	health_component.take_damage()
