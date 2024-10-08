extends Area2D

@export var initial_bullet_speed : int
@export var acceleration : int
@export var rotation_speed : int
@export var distance_to_max_distance : float 

var decelerating : bool = false
var bullet_speed
var direction : Vector2
var damage : float
var max_distance : float
var distance : float = 0
var enemies_hit := []
var forwards := true

func _ready() -> void:
	bullet_speed = initial_bullet_speed
	if max_distance > 300:
		damage *= 0.5

func _physics_process(delta: float) -> void:
	position += direction * bullet_speed * delta
	rotation += rotation_speed * delta
	distance += (direction * bullet_speed * delta).length()
	if distance + distance_to_max_distance > max_distance and not decelerating:
		decelerating = true
	if bullet_speed >= -1 * initial_bullet_speed and decelerating:
		bullet_speed -= acceleration * delta
	if forwards and bullet_speed < 0:
		enemies_hit.clear()
		damage *= 1.5
		forwards = false
	
	

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage") and area not in enemies_hit:
		area.take_damage(damage)
		enemies_hit.append(area)

func destroy() -> void:
	if bullet_speed < 0:
		queue_free()
