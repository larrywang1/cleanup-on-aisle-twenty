extends Node2D

var launcher_attack := preload("res://aisles/bosses/banana/banana_launcher.tscn")
var second_attack : bool = false
@onready var projectiles : Node2D = get_tree().get_first_node_in_group("projectiles")
@onready var player : Node2D = get_tree().get_first_node_in_group("player")

func fire(is_angry : bool):
	var count = 2 if is_angry else 1
	for i in range(count):
		fire_four_quadrants()
	if is_angry or second_attack:
		fire_on_player()
	second_attack = not second_attack

func fire_on_player():
	var attack_instance = launcher_attack.instantiate()
	attack_instance.global_position = Vector2(player.global_position.x + randf_range(-10.0, 10.0), player.global_position.y + randf_range(-10.0, 10.0))
	projectiles.add_child(attack_instance)

var coordinates_x : Array[Array] = [[-260.0, -40.0], [40.0, 260.0]]
var coordinates_y : Array[Array] = [[-130.0, -40.0], [60.0, 130.0]]
func fire_four_quadrants():
	for x in coordinates_x:
		for y in coordinates_y:
			var attack_instance = launcher_attack.instantiate()
			attack_instance.global_position = Vector2(randf_range(x[0], x[1]), randf_range(y[0], y[1]))
			projectiles.add_child(attack_instance)
