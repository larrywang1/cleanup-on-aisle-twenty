extends Node

@export var animation_player : AnimationPlayer
@export var attack_1 : Node2D
@export var attack_2 : Node2D
@export var attack_3 : Node2D
@export var start_timer : Timer
@export var attack_timer : Timer
@export var transition_timer : Timer
enum states {
	INACTIVE,
	ONE,
	TWO
}
var state : states = states.INACTIVE

func spawn_attack_2() -> void:
	attack_2.set_physics_process(true)
	attack_3.set_physics_process(false)
	animation_player.current_animation = "angry"
	Spawning.spawn(attack_2, "grapehalf2", "0", -2)

func spawn_attack_1() -> void:
	Spawning.spawn(attack_1, "grapehalf1", "0", -2)

func spawn_attack_3() -> void:
	attack_2.set_physics_process(false)
	attack_3.set_physics_process(true)
	animation_player.current_animation = "angry2"
	Spawning.spawn(attack_3, "grapehalf3", "0", -2)

func start() -> void:
	start_timer.start()

func _on_start_timeout() -> void:
	Spawning.process_stop_all = false
	spawn_attack_2()
	attack_timer.start()
	state = states.ONE

func _on_attack_timeout() -> void:
	transition_timer.start()

func _on_transition_timeout() -> void:
	if state == states.ONE:
		state = states.TWO
		spawn_attack_3()
	elif state == states.TWO:
		state = states.ONE
		spawn_attack_2()
	attack_timer.start()
