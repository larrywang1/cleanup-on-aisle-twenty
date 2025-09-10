extends Node2D

@onready var aisle_manager : Node2D = $AisleManager
@onready var projectiles : Node2D = $Projectiles
@onready var entities : Node2D = $Entities

func _ready() -> void:
	initialize()

func initialize() -> void:
	Spawning.bullet_collided_area.connect(bullet_hit)
	EventBus.boss_died.connect(start_cutscene)
	EventBus.player_died.connect(player_died)

func bullet_hit(_area:Area2D, _area_shape_index:int, _bullet:Dictionary, _local_shape_index:int, _shared_area:Area2D) -> void:
	RunManager.player.health_component.take_damage()

var cutscene := preload("res://aisles/cutscenes/cutscene.tscn")
func start_cutscene(animation : String) -> void:
	var cutscene_instance := cutscene.instantiate()
	cutscene_instance.animation = animation
	add_child(cutscene_instance)
	
	reset()

func player_died() -> void:
	for object in projectiles.get_children():
		object.queue_free()
	call_deferred("reset_game")
	
func reset_game() -> void:
	Spawning.reset()
	RunManager.reset()
	get_tree().reload_current_scene()

func reset() -> void:
	for object in projectiles.get_children():
		object.queue_free()
	RunManager.player.position = Vector2(0, 194)
	call_deferred("pause_tree")
	Spawning.call_deferred("reset")
	aisle_manager.call_deferred("change_boss")

func pause_tree() -> void:
	get_tree().paused = true
