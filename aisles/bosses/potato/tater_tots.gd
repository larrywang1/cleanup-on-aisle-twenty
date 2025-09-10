extends Node2D
var tater_tot = preload("res://aisles/bosses/potato/tater_tot.tscn")
func _on_timer_timeout() -> void:
	spawn(2)


func spawn(amount) -> void:
	for i in range(amount):
		var tater_tot_instance = tater_tot.instantiate()
		tater_tot_instance.global_position = Vector2(randf_range(-300, 300), randf_range(-150, 150))
		call_deferred("add_child", tater_tot_instance)
