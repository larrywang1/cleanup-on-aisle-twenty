extends Node2D

@export var environment : Node2D
@export var entities : Node2D
var bosses : Array = [
	[preload("res://aisles/bosses/grape/grape_boss.tscn")],
	[preload("res://aisles/bosses/banana/banana_boss.tscn")]
]
var sections : Array = [
	preload("res://aisles/sections/section1/section1.tscn")
]

var section : int = 0
var aisle : int = 0
var current_section : CanvasLayer

func _ready() -> void:
	EventBus.change_scene.connect(change_section)
	change_section()
	change_boss()

func change_section() -> void:
	section += 1
	if current_section:
		current_section.queue_free()
	current_section = sections[section - 1].instantiate()
	environment.add_child(current_section)

func change_boss() -> void:
	aisle += 1
	for boss in bosses[aisle - 1]:
		var current_boss = boss.instantiate()
		entities.add_child(current_boss)
