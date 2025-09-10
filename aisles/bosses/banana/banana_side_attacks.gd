extends Node2D

@onready var spawnpoints : Array[Array] = [[$"../Spawnpoints/NNW",$"../Spawnpoints/SSW"],[$"../Spawnpoints/NNE",$"../Spawnpoints/SSE"],[$"../Spawnpoints/WNW", $"../Spawnpoints/ENE"],[$"../Spawnpoints/WSW",$"../Spawnpoints/ESE"]]
@onready var warnings : Array[Array] = [[$"../Spawnpoints/NNW/Warning",$"../Spawnpoints/SSW/Warning"],[$"../Spawnpoints/NNE/Warning",$"../Spawnpoints/SSE/Warning"],[$"../Spawnpoints/WNW/Warning",$"../Spawnpoints/ENE/Warning"],[$"../Spawnpoints/WSW/Warning",$"../Spawnpoints/ESE/Warning"]]
var order : Array[int] = [0,1,2,3]
var order_2 : Array[int] = [0, 0]
var is_angry : bool = false
var can_fire : bool = true
var spawnpoints_to_fire : Array = []
@onready var warning_timer : Timer = $WarningTimer
@onready var attack_timer : Timer = $AttackTimer

func _ready() -> void:
	Spawning.create_pool("bananahorizontal", "0", 150)
	Spawning.create_pool("bananavertical", "0", 250)
	order.shuffle()
	shuffle_order_2()

func _on_attack_timer_timeout() -> void:
	order.shuffle()
	shuffle_order_2()
	warning()
	attack_timer.wait_time = randf_range(10, 12)
	
func attack() -> void:
	for spawn in spawnpoints_to_fire:
		spawn.get_child(0).visible = false
		Spawning.spawn(spawn, spawn.auto_pattern_id, "0", -1)

func warning() -> void:
	spawnpoints_to_fire.clear()
	if can_fire:
		if not is_angry:
			spawnpoints_to_fire.append(spawnpoints[order[0]][order_2[0]])
			spawnpoints_to_fire.append(spawnpoints[order[1]][order_2[1]])
		if is_angry:
			spawnpoints_to_fire.append(spawnpoints[order[0]][0])
			spawnpoints_to_fire.append(spawnpoints[order[0]][1])
			spawnpoints_to_fire.append(spawnpoints[order[1]][0])
			spawnpoints_to_fire.append(spawnpoints[order[1]][1])
	for spawn in spawnpoints_to_fire:
		spawn.get_child(0).visible = true
	warning_timer.start()

func shuffle_order_2() -> void:
	order_2[0] = randi_range(0, 1)
	order_2[1] = randi_range(0, 1)
