extends Node2D

var watermelon_attack_1 = preload("res://aisles/bosses/watermelon/watermelon_bullet.tscn")
@onready var projectiles : Node2D = get_tree().get_first_node_in_group("projectiles")
@export var burst_timer : Timer
@export var attack_1 : Timer
@export var spawnpoint_seed : Node2D
var state : bool = true
var angry : bool = false
var lower : int = 3
var higher : int = 4

func _ready() -> void:
	Spawning.create_pool("watermelon_slice", "0", 500)
	Spawning.create_pool("watermelon_seed_1", "0", 300)
	tween_spawnpoint()

func tween_spawnpoint() -> void:
	var tween = create_tween()
	tween.tween_property(spawnpoint_seed, "rotation_degrees", -300, 1)
	tween.tween_property(spawnpoint_seed, "rotation_degrees", -60, 1)
	await tween.finished
	tween_spawnpoint()

func start() -> void:
	$AttackSwitch.start()
	attack_1.start()
	call_deferred("_on_attack_1_timeout")

func spawn_bullet() -> void:
	var watermelon_attack = watermelon_attack_1.instantiate()
	watermelon_attack.global_position = Vector2(430, randf_range(-225, 225))
	watermelon_attack.timer.wait_time = randf_range(0.5, 3.5)
	projectiles.add_child(watermelon_attack)

func _on_attack_1_timeout() -> void:
	for i in range(randi_range(lower, higher)):
		spawn_bullet()
		burst_timer.start()
		await burst_timer.timeout

func _on_attack_switch_timeout() -> void:
	if state:
		lower = 0
		higher = 0 if not angry else 1
		Spawning.spawn(spawnpoint_seed, "watermelon_seed_1")
	else:
		lower = 3
		higher = 4
	state = !state
