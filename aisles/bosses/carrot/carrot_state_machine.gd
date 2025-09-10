extends Node2D

enum states {
	SPINNING,
	DASHING,
	STATIONARY,
	INACTIVE
}
var state : states = states.INACTIVE
@export var animation : AnimationPlayer
@export var speed : int
@export var character : CharacterBody2D
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
var top_left : Array = [Vector2(-350, -200), Vector2(-300, -200), Vector2(-250, -200), Vector2(-200, -200), Vector2(-150, -200), Vector2(-100, -200), Vector2(-50, -200), Vector2(-350, -150), Vector2(-350, -100), Vector2(-350, -50), Vector2(-350, 0), Vector2(-350, 50), Vector2(-350, 100), Vector2(-350, 150), Vector2(350, -200), Vector2(300, -200), Vector2(250, -200), Vector2(200, -200), Vector2(150, -200), Vector2(100, -200), Vector2(50, -200)]
var bottom_right : Array = [Vector2(350, 200), Vector2(300, 200), Vector2(250, 200), Vector2(200, 200), Vector2(150, 200), Vector2(100, 200), Vector2(50, 200), Vector2(350, -150), Vector2(350, -100), Vector2(350, -50), Vector2(350, 0), Vector2(350, 50), Vector2(350, 100), Vector2(350, 150), Vector2(-350, 200), Vector2(-300, 200), Vector2(-250, 200), Vector2(-200, 200), Vector2(-150, 200), Vector2(-100, 200), Vector2(-50, 200)]
var all : Array = top_left + bottom_right
var angry : bool = false
var carrot_projectile := preload("res://aisles/bosses/carrot/carrot_projectile.tscn")
@onready var projectiles = get_tree().get_first_node_in_group("projectiles")

func _ready() -> void:
	Spawning.create_pool("carrot", "0", 80)

func initialize() -> void:
	enter_state(states.SPINNING)

func enter_state(state_to_change) -> void:
	match state_to_change:
		states.SPINNING:
			spinning_enter()
		states.DASHING:
			dashing_enter()
		states.STATIONARY:
			stationary_enter()

func spinning_enter() -> void:
	animation.current_animation = "startspin"

var count : int
func spinning_start() -> void:
	count = 18
	$ShootTimer.start()
	animation.current_animation = "spin"
	state = states.SPINNING
	$RunningTimer.start()
	Spawning.spawn($"../BulletUpHell/SpawnPoint", "carrot")
	
func running_timer_end() -> void:
	enter_state(states.DASHING)
	
func dashing_enter() -> void:
	animation.current_animation = "bite"
	state = states.DASHING
	dash_amounts = 5
	dash()

var fire_count : int
func stationary_enter() -> void:
	state = states.STATIONARY
	animation.current_animation = "active"
	var tween = create_tween()
	tween.tween_property(character, "global_position", Vector2(0, 0), 2)
	fire_count = 3
	$Timer.start()

func fire() -> void:
	for i in range(5):
		var carrot_projectile_instance = carrot_projectile.instantiate()
		var rand_var = randi_range(0, 1)
		carrot_projectile_instance.global_position = top_left.pick_random() if rand_var else bottom_right.pick_random()
		carrot_projectile_instance.behavior = carrot_projectile_instance.behaviors.TRACK
		projectiles.add_child(carrot_projectile_instance)
	fire_count -= 1

func _process(delta) -> void:
	match state:
		states.SPINNING:
			spinning_process(delta)
		states.DASHING:
			dashing_process(delta)

var is_stunned : bool = false
func spinning_process(delta) -> void:
	if not is_stunned:
		character.global_position += (player.global_position - character.global_position).normalized() * delta * speed

func stun(_area) -> void:
	is_stunned = true
	$StunTimer.start()

func unstun() -> void:
	is_stunned = false

@export var arrow : Sprite2D
var direction : Vector2
var dashing_speed := 1500
var can_dash : bool = false
var dash_amounts : int = 5
func dashing_process(_delta) -> void:
	if can_dash:
		character.velocity = direction * dashing_speed
		character.move_and_slide()

func dash() -> void:
	dash_amounts -= 1
	direction = (player.global_position - character.global_position).normalized()
	arrow.rotation = direction.angle()
	arrow.visible = true
	arrow.modulate.a = 1
	var tween = create_tween()
	tween.tween_property(arrow, "modulate:a", 0, 0.75)
	await tween.finished
	can_dash = true
	$DashTimer.start()
	

func _on_shoot_timer_timeout() -> void:
	if angry:
		$ShootTimer.wait_time = 3.5
	var carrot_projectile_instance = carrot_projectile.instantiate()
	var rand_var = randi_range(0, 1)
	carrot_projectile_instance.global_position = top_left.pick_random() if rand_var else bottom_right.pick_random()
	if not angry:
		carrot_projectile_instance.behavior = carrot_projectile_instance.behaviors.RANDOM
	else:
		carrot_projectile_instance.behavior = carrot_projectile_instance.behaviors.TRAIL
	if rand_var:
		carrot_projectile_instance.target_position = bottom_right.pick_random()
	else:
		carrot_projectile_instance.target_position = top_left.pick_random()
	projectiles.add_child(carrot_projectile_instance)
	count -= 1
	if count == 0:
		$ShootTimer.stop()


func _on_dash_timer_timeout() -> void:
	can_dash = false
	if dash_amounts == 0:
		enter_state(states.STATIONARY)
	else:
		dash()


func _on_timer_timeout() -> void:
	if fire_count == 0:
		$Timer.stop()
		enter_state(states.SPINNING)
	else:
		fire()
