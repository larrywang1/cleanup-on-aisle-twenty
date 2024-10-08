extends CharacterBody2D

@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D

@export var spawnpoints : Node2D
@export var attack_1 : Node
@export var attack_2 : Node
@export var grape_full_1 : Node2D

var is_tweening : bool = false
enum states {
	INACTIVE,
	ACTIVE,
	ANGRY
}
var state : states = states.INACTIVE

func _ready() -> void:
	animation_player.current_animation = "inactive"
	Spawning.create_pool("grapefull1", "0", 250)
	Spawning.create_pool("grapefull2", "0", 150)
	Spawning.create_pool("grapefull3", "0", 150)
	Spawning.create_pool("grapehalf1", "0", 500)
	
	EventBus.boss_first_damaged.connect(first_damaged)
	EventBus.boss_health_changed.connect(damaged)
	EventBus.boss_fifty_percent.connect(fifty_percent)
	EventBus.boss_died.connect(died)
	

func first_damaged() -> void:
	animation_player.current_animation = "active"
	state = states.ACTIVE
	attack_1.start()
	
func spawn_full_one() -> void:
	if not Spawning.process_stop_all:
		Spawning.spawn(grape_full_1, "grapefull1", "0", -1)
		grape_full_1.set_physics_process(true)

func fifty_percent() -> void:
	state = states.ANGRY
	attack_1.stop()
	Spawning.process_kill(-1)
	attack_2.call_deferred("start")

func damaged(_damage) -> void:
	if not is_tweening:
		is_tweening = true
		var tween = create_tween()
		sprite.material.set_shader_parameter("flash_amount", 1.0)
		tween.tween_property(sprite.material, "shader_parameter/flash_amount", 0.7, 0.15)
		await tween.finished
		sprite.material.set_shader_parameter("flash_amount", 0.0)
		is_tweening = false

func died(_animation) -> void:
	Spawning.process_kill_all()
	Spawning.clear_all_bullets()
	queue_free()
