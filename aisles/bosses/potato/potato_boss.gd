extends CharacterBody2D

@export var sprite : Sprite2D

@onready var player := get_tree().get_first_node_in_group("player")
var is_tweening : bool = false
enum states {
	INACTIVE,
	ACTIVE,
	ANGRY
}
var state : states = states.INACTIVE

func _ready() -> void:
	EventBus.boss_first_damaged.connect(first_damaged)
	EventBus.boss_health_changed.connect(damaged)
	EventBus.boss_fifty_percent.connect(fifty_percent)
	EventBus.boss_died.connect(died)
	EventBus.minion_died.connect(minion_died)
	Spawning.process_stop_all = false

func _process(_delta : float) -> void:
	$Sprite2D/Eyes.position = Vector2(0, 0) + 15 * (player.global_position - global_position).normalized()
	
func first_damaged() -> void:
	state = states.ACTIVE
	$"../RotatingAttack".start()
	$"../TaterTots/Timer".start()
	$"../TaterTots".spawn(2)
	$"../MiniPotatos/MiniPotato".init()
	$"../MiniPotatos/MiniPotato2".init()

func fifty_percent() -> void:
	state = states.ANGRY

func damaged(_damage) -> void:
	if not is_tweening:
		is_tweening = true
		var tween = create_tween()
		tween.set_parallel()
		sprite.material.set_shader_parameter("flash_amount", 0.95)
		$Sprite2D/Eyes.material.set_shader_parameter("flash_amount", 0.95)
		tween.tween_property(sprite.material, "shader_parameter/flash_amount", 0.7, 0.15)
		tween.tween_property($Sprite2D/Eyes.material, "shader_parameter/flash_amount", 0.7, 0.15)
		await tween.finished
		sprite.material.set_shader_parameter("flash_amount", 0.0)
		$Sprite2D/Eyes.material.set_shader_parameter("flash_amount", 0.0)
		is_tweening = false

func died(_animation) -> void:
	Spawning.clear_all_bullets()
	get_parent().queue_free()

func minion_died(damage) -> void:
	$BossHealthComponent.take_damage(damage)
