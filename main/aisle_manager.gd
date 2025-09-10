extends Node2D

@export var environment : Node2D
@export var entities : Node2D
var bosses : Array = [
	[preload("res://aisles/bosses/grape/grape_boss.tscn")],
	[preload("res://aisles/bosses/watermelon/watermelon_boss.tscn")],
	[preload("res://aisles/bosses/banana/banana_boss.tscn")],
	[preload("res://aisles/bosses/carrot/carrot_boss.tscn")],
	[preload("res://aisles/bosses/potato/potato_boss.tscn")]
]
var sections : Array = [
	preload("res://aisles/sections/section1/section1.tscn"),
	preload("res://aisles/sections/section2/section2.tscn")
]

var current_section : CanvasLayer

func _ready() -> void:
	EventBus.section_change.connect(change_section)
	change_section()
	change_boss()

func change_section() -> void:
	RunManager.section += 1
	if current_section:
		current_section.queue_free()
	current_section = sections[RunManager.section - 1].instantiate()
	environment.add_child(current_section)

func change_boss() -> void:
	RunManager.aisle += 1
	for boss in bosses[RunManager.aisle - 1]:
		var current_boss = boss.instantiate()
		entities.add_child(current_boss)
