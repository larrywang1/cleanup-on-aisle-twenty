extends CharacterBody2D

@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D
@export var large_banana : Sprite2D
@export var banana_launcher : Node2D 
@export var side_attacks : Node2D

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
	side_attacks.warning()

func fifty_percent() -> void:
	state = states.ANGRY
	side_attacks.is_angry = true

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

func fire_banana() -> void:
	large_banana.visible = true
	var tween = create_tween()
	tween.tween_property(large_banana, "position:y", -300, 0.2)
	await tween.finished
	large_banana.visible = false
	large_banana.position = Vector2(31, -27)
	banana_launcher.fire(true if state == states.ANGRY else false)
