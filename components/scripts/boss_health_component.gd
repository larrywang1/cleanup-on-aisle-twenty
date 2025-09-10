extends Node2D

@export var max_health : float
@export var boss_cutscene_animation_string : String
@export var section_change : bool
@export var damage_reduction : float = 0
var health : float 

func _ready() -> void:
	health = max_health
	EventBus.boss_spawned.emit(max_health)

func take_damage(damage : float) -> void:
	if health == max_health:
		EventBus.boss_first_damaged.emit()
	health -= (damage * (1 - damage_reduction))
	if health <= max_health / 2 and health + damage > max_health / 2:
		EventBus.boss_fifty_percent.emit()
	if health <= 0:
		EventBus.boss_died.emit(boss_cutscene_animation_string)
		if section_change:
			EventBus.section_change.emit()
		return
	EventBus.boss_health_changed.emit(damage * (1 - damage_reduction))
