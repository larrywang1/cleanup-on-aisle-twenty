extends Area2D

@export var force : float

func _on_area_entered(area: Area2D) -> void:
	RunManager.player.health_component.take_damage()
	RunManager.player.health_component.player.apply_force(force, (area.global_position - global_position).normalized())
