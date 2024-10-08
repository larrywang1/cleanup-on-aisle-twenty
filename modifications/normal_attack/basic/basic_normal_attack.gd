extends Node2D

@onready var projectiles := get_tree().get_first_node_in_group("projectiles")
@onready var player := get_tree().get_first_node_in_group("player")
@onready var attack_component = get_tree().get_first_node_in_group("attack_component")
var bullet := preload("res://modifications/normal_attack/basic/basic_normal_bullet.tscn")
@export var damage_scaling : float
@export var spawn_marker : Marker2D
@export var attack_speed : float
@export var shake_time : float
@export var shake_amount : float
@export var slow : int

func _ready() -> void:
	attack_component.set_attack_time(attack_speed)

func fire(direction : Vector2) -> void:
	EventBus.screenshake.emit(shake_time, shake_amount)
	var bullet_instance := bullet.instantiate()
	bullet_instance.direction = direction
	bullet_instance.damage = player.damage * player.damage_amplification * damage_scaling
	bullet_instance.global_position = spawn_marker.global_position
	projectiles.add_child(bullet_instance)
