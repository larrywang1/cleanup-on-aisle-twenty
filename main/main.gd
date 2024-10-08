extends Node2D

@onready var player_health_comp := get_tree().get_first_node_in_group("player_health")
@onready var aisle_manager : Node2D = $AisleManager
@onready var player : CharacterBody2D = $Entities/Player
@onready var projectiles : Node2D = $Projectiles

func _ready() -> void:
	initialize()

func initialize() -> void:
	Spawning.bullet_collided_area.connect(bullet_hit)
	EventBus.boss_died.connect(start_cutscene)

func bullet_hit(_area:Area2D, _area_shape_index:int, _bullet:Dictionary, _local_shape_index:int, _shared_area:Area2D) -> void:
	player_health_comp.take_damage()

var cutscene := preload("res://aisles/cutscenes/cutscene.tscn")
func start_cutscene(animation : String) -> void:
	var cutscene_instance := cutscene.instantiate()
	cutscene_instance.animation = animation
	add_child(cutscene_instance)
	
	reset()

func reset() -> void:
	for object in projectiles.get_children():
		object.queue_free()
	Spawning.reset()
	player.position = Vector2(0, 194)
	aisle_manager.call_deferred("change_boss")
	call_deferred("pause_tree")

func pause_tree() -> void:
	get_tree().paused = true
