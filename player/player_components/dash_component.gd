extends Node2D

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@export var dash_timer : Timer
@export var dash_speed : int
@export var ghost_timer : Timer
var original_speed : Vector2
var original_direction : Vector2
@export var stamina_component : Node2D
@export var health_component : Node2D
@export var attack_component : Node2D
@export var invin_timer : Timer

var ghost := preload("res://player/ghost/ghost.tscn")

func dash(aimed_direction : Vector2, speed : Vector2, direction : Vector2) -> void:
	attack_component.cancel()
	player.can_dash = false
	player.is_dashing = true
	player.movement_direction = aimed_direction
	player.velocity = aimed_direction.normalized() * dash_speed
	
	ghost_timer.start()
	
	original_speed = speed
	original_direction = direction
	stamina_component.use_stamina()
	dash_timer.start()
	health_component.state = health_component.states.INVIN
	invin_timer.start()

func _on_dash_cooldown_timeout() -> void:
	if stamina_component.stamina != 0:
		player.can_dash = true
	player.is_dashing = false
	player.movement_direction = original_direction
	player.velocity = original_speed
	ghost_timer.stop()


func spawn_ghost() -> void:
	var ghost_instance := ghost.instantiate()
	ghost_instance.global_position = player.global_position
	ghost_instance.rotation = player.aiming_direction.angle() - Vector2(0, -1).angle()
	get_tree().current_scene.add_child(ghost_instance)


func _on_invin_timer_timeout() -> void:
	if not health_component.invin_timer.time_left:
		health_component.state = health_component.states.VULN
