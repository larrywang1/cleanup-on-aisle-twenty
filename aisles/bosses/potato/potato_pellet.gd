extends CharacterBody2D

var direction
@export var speed = 100

func _physics_process(delta: float) -> void:
	velocity = direction * speed * delta
	var player = move_and_collide(velocity)
	if player == RunManager.player:
		EventBus.player_hit.emit()


func _on_timer_timeout() -> void:
	set_physics_process(false)
	$Explosion.visible = true
	$Explosion.play()
	if $Area2D.get_overlapping_bodies():
		RunManager.player.health_component.take_damage()
		RunManager.player.health_component.player.apply_force(500, (get_tree().get_first_node_in_group("player").global_position - global_position).normalized())
	await $Explosion.animation_finished
	queue_free()
