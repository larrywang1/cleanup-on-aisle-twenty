extends Node2D

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@export var max_stamina : int
@export var stamina_timer : Timer
@export var initial_stamina_cooldown : float
@export var stamina_cooldown : float
var stamina : int


func _ready() -> void:
	stamina = max_stamina
	for i in range(max_stamina):
		EventBus.add_stamina.emit()

func use_stamina() -> void:
	stamina -= 1
	EventBus.lose_stamina.emit()
	stamina_timer.wait_time = initial_stamina_cooldown
	if not stamina_timer.time_left:
		stamina_timer.start()
	else:
		change_timer(initial_stamina_cooldown)
	if stamina == 0:
		player.can_dash = false

func recover_stamina() -> void:
	stamina += 1
	EventBus.restore_stamina.emit()
	if stamina_timer.wait_time == initial_stamina_cooldown:
		change_timer(stamina_cooldown)
	if stamina == max_stamina:
		stamina_timer.stop()
	if stamina == 1:
		player.can_dash = true

func change_timer(time : float):
	stamina_timer.stop()
	stamina_timer.wait_time = time
	stamina_timer.start()
