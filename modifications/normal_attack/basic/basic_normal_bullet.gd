extends Area2D

@export var bullet_speed : int
var direction : Vector2
var damage : float

func _physics_process(delta: float) -> void:
	position += direction * bullet_speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(damage)
		destroy()

func destroy() -> void:
	queue_free()
