extends Area2D


func _on_area_entered(_area: Area2D) -> void:
	get_tree().get_first_node_in_group("player_health").take_damage()
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
