extends Area2D

@export var speed : float
@export var rotation_speed : float
var direction : Vector2 = Vector2(-1, 0)
@export var spawnpoint : Node2D
@export var timer : Timer
@export var sprite : AnimatedSprite2D

signal spawn_watermelon_bullet(spawnpoint)

func _ready() -> void:
	$Timer.wait_time = timer.wait_time - 0.5
	$Timer.start()

func _physics_process(delta: float) -> void:
	position += speed * direction * delta
	rotation += rotation_speed * delta

func _on_area_entered(_area: Area2D) -> void:
	EventBus.player_hit.emit()

func _on_life_time_timeout() -> void:
	Spawning.spawn(spawnpoint, "watermelon_attack_1")
	queue_free()

func _on_timer_timeout() -> void:
	sprite.frame = 1
