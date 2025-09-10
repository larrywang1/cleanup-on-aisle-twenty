extends CharacterBody2D
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D
@export var attack_pattern : Node2D

var is_tweening : bool = false
enum states {
	INACTIVE,
	ACTIVE,
	ANGRY
}
var state : states = states.INACTIVE

func _ready() -> void:
	animation_player.current_animation = "inactive"
	EventBus.boss_first_damaged.connect(first_damaged)
	EventBus.boss_health_changed.connect(damaged)
	EventBus.boss_fifty_percent.connect(fifty_percent)
	EventBus.boss_died.connect(died)
	Spawning.process_stop_all = false

	
func first_damaged() -> void:
	animation_player.current_animation = "active"
	state = states.ACTIVE
	attack_pattern.start()

func fifty_percent() -> void:
	state = states.ANGRY
	attack_pattern.angry = true

func damaged(_damage) -> void:
	if not is_tweening:
		is_tweening = true
		var tween = create_tween()
		sprite.material.set_shader_parameter("flash_amount", 0.95)
		tween.tween_property(sprite.material, "shader_parameter/flash_amount", 0.7, 0.15)
		await tween.finished
		sprite.material.set_shader_parameter("flash_amount", 0.0)
		is_tweening = false

func died(_animation) -> void:
	Spawning.clear_all_bullets()
	queue_free()
