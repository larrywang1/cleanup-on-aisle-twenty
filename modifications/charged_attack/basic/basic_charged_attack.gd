extends Node2D

@onready var projectiles := get_tree().get_first_node_in_group("projectiles")
@onready var player := get_tree().get_first_node_in_group("player")
var bullet := preload("res://modifications/charged_attack/basic/basic_charged_bullet.tscn")
@export var damage_scaling : float
@export var spawn_marker : Marker2D
@export var charge_timer : Timer
@export var shake_time : float
@export var shake_amount : float
@export var slow : int
var can_fire : bool = false

func fire(direction : Vector2) -> void:
	EventBus.screenshake.emit(shake_time, shake_amount)
	var bullet_instance := bullet.instantiate()
	bullet_instance.direction = direction
	bullet_instance.damage = player.damage * player.damage_amplification * damage_scaling
	bullet_instance.global_position = spawn_marker.global_position
	projectiles.add_child(bullet_instance)

func start() -> void:
	charge_timer.start()
	can_fire = true

func release(direction : Vector2) -> void:
	if charge_timer.time_left:
		charge_timer.stop()
		return
	elif can_fire:
		fire(direction)
	can_fire = false
	charge_timer.stop()

func cancel() -> void:
	charge_timer.stop()
	can_fire = false
	return
