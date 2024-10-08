extends Area2D

@onready var player_health_comp := get_tree().get_first_node_in_group("player_health")
@export var force : float

func _on_area_entered(area: Area2D) -> void:
	player_health_comp.take_damage()
	player_health_comp.player.apply_force(force, (area.global_position - global_position).normalized())
