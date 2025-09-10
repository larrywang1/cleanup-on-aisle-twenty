extends CharacterBody2D
class_name Player

var can_move : bool = true
var can_aim : bool = true
var can_dash : bool = true
var is_dashing : bool = false
var movement_direction : Vector2
var aiming_direction : Vector2

@export var damage : float
var damage_amplification : float = 1.0

@export_group("Movement")
@export var original_max_speed : int = 130
@export var max_speed : int = 130
@export var acceleration : int
@export var friction : int

@export_group("Components")
@export var dash_component : Node2D
@export var stamina_component : Node2D
@export var health_component : Node2D
@export var hurtbox_component : Node2D
@export var attack_component : Node2D
@export_group("")

func _ready() -> void:
	RunManager.player = self

func _physics_process(delta: float) -> void:
	if can_move:
		if not is_dashing:
			get_movement_input()
		apply_movement(delta)
	if can_aim:
		aiming_direction = (get_global_mouse_position() - global_position)
		rotation = aiming_direction.angle() - Vector2(0, -1).angle()
	if Input.is_action_just_pressed("dash") and can_dash:
		dash_component.dash(aiming_direction, velocity, movement_direction)
	if Input.is_action_just_pressed("reset"):
		EventBus.player_died.emit()

func get_movement_input() -> void:
	movement_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func apply_movement(delta : float) -> void:
	if movement_direction:
		velocity = velocity.move_toward(movement_direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2(0, 0), friction * delta)
	move_and_slide()

func apply_force(force : float, direction : Vector2) -> void:
	velocity = direction * force
