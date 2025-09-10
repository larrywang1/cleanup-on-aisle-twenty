extends Node

@onready var player : CharacterBody2D = RunManager.player
@onready var grape : CharacterBody2D = $".."
@onready var full2 : Timer = $Full2
@onready var full3 : Timer = $Full3
@onready var transition : Timer = $Transition
@export var pivot_strength : float = 5
@export var grape_full_2 : Node2D
@export var grape_full_3 : Node2D
@export var grape_full_4 : Node2D
enum states {
	INACTIVE,
	SPIRAL,
	SPRAY
}
var state : states = states.INACTIVE

func _ready() -> void:
	full2.timeout.connect(start_transition)
	full3.timeout.connect(start_transition)
	transition.timeout.connect(spawn_pattern)
	set_process(false)
	

func start() -> void:
	$Start.start()

func _process(delta : float) -> void:
	if grape_full_3.rotation > player.global_position.normalized().angle():
		grape_full_3.rotation = lerp(grape_full_3.rotation, player.global_position.normalized().angle(), pivot_strength * delta)
		grape_full_4.rotation = lerp(grape_full_4.rotation, player.global_position.normalized().angle(), pivot_strength * delta)
	else:
		grape_full_3.rotation = lerp(player.global_position.normalized().angle(), grape_full_3.rotation, pivot_strength * delta)
		grape_full_4.rotation = lerp(player.global_position.normalized().angle(), grape_full_4.rotation, pivot_strength * delta)

func spawn_pattern() -> void:
	if state == states.SPRAY:
		Spawning.spawn(grape_full_2, "grapefull2", "0", -1)
		grape_full_2.set_physics_process(true)
		state = states.SPIRAL
		full2.start()
		set_process(false)
	elif state == states.INACTIVE or state == states.SPIRAL:
		grape_full_3.rotation = player.global_position.normalized().angle()
		grape_full_4.rotation = player.global_position.normalized().angle()
		set_process(true)
		Spawning.spawn(grape_full_4, "grapefull4", "0", -1)
		Spawning.spawn(grape_full_3, "grapefull3", "0", -1)
		state = states.SPRAY
		full3.start()



func start_transition() -> void:
	transition.start()

func stop() -> void:
	full2.stop()
	full3.stop()
	transition.stop()
	grape_full_2.set_physics_process(false)
	set_process(false)


func _on_start_timeout() -> void:
	spawn_pattern()
