extends Node2D

@export var normal_attack : Node2D
@export var charged_attack : Node2D
@export var cooldown_timer : Timer
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
enum states {
	INACTIVE,
	NORMAL,
	CHARGING
}
var state : states = states.INACTIVE

func _process(_delta: float) -> void:
	if not player.is_dashing:
		if Input.is_action_just_pressed("normal") and state == states.INACTIVE:
			state = states.NORMAL
		elif Input.is_action_just_pressed("charged"):
			state = states.CHARGING
			start_charged_attack()
		if Input.is_action_just_released("normal"):
			state = states.INACTIVE
		elif Input.is_action_just_released("charged"):
			state = states.INACTIVE
			charged_attack.get_child(0).release(player.aiming_direction.normalized())
		if state == states.NORMAL and not cooldown_timer.time_left:
			normal()
	if state == states.NORMAL:
		player.max_speed = player.original_max_speed - normal_attack.get_child(0).slow
	elif state == states.CHARGING:
		player.max_speed = player.original_max_speed - charged_attack.get_child(0).slow
	elif state == states.INACTIVE:
		player.max_speed = player.original_max_speed

func normal() -> void:
	normal_attack.get_child(0).fire(player.aiming_direction.normalized())
	cooldown_timer.start()

func start_charged_attack() -> void:
	charged_attack.get_child(0).start()

func cancel() -> void:
	if state == states.CHARGING:
		charged_attack.get_child(0).cancel()
	state = states.INACTIVE

func set_attack_time(time : float):
	cooldown_timer.wait_time = time
