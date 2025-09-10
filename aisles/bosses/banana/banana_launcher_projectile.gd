extends Area2D
@onready var projectile : AnimatedSprite2D = $Projectile
@onready var health_component : Node2D = get_tree().get_first_node_in_group("player_health")

func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(projectile, "position:y", -48, 0.3)
	await tween.finished
	projectile.play()
	if has_overlapping_areas():
		if health_component.hurtbox in get_overlapping_areas():
			health_component.take_damage()
	await projectile.animation_finished
	queue_free()
