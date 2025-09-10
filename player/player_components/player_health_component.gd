extends Node2D

@onready var player := get_tree().get_first_node_in_group("player")
@export var max_health : int
var health : int
@export var invin_timer : Timer
@export var hurtbox : Area2D
@export var blink_timer : Timer
@export var shake_time : float
@export var shake_amount : float
@export var sprite : Sprite2D
var is_blinking : bool = false
enum states {
	INVIN,
	VULN}
var state := states.VULN

func _ready() -> void:
	health = max_health
	for i in range(max_health):
		EventBus.add_health.emit()

func _physics_process(_delta : float) -> void:
	if state == states.VULN:
		hurtbox.set_collision_layer_value(4, true)
	if state == states.INVIN:
		hurtbox.set_collision_layer_value(4, false)

func take_damage() -> void:
	if state == states.VULN:
		EventBus.screenshake.emit(shake_time, shake_amount)
		health -= 1
		if health == 0:
			EventBus.player_died.emit()
			return
		state = states.INVIN
		invin_timer.start()
		EventBus.lose_health.emit()
		flash()
	

func _on_invin_timer_timeout() -> void:
	blink_timer.stop()
	sprite.visible = true
	if not player.is_dashing:
		state = states.VULN

func flash() -> void:
	var tween = create_tween()
	sprite.material.set_shader_parameter("flash_amount", 1.0)
	tween.tween_property(sprite.material, "shader_parameter/flash_amount", 0.7, 0.2)
	await tween.finished
	sprite.material.set_shader_parameter("flash_amount", 0.0)
	start_blinking()

func start_blinking() -> void:
	blink_timer.start()

func _on_blink_timer_timeout() -> void:
	
	sprite.visible = !sprite.visible
