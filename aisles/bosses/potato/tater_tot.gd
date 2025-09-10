extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var speed := 200
var shader = preload("res://miscellaneous/enemy_flash.tres")
func _ready() -> void:
	$TaterTot.material = shader.duplicate()
	set_physics_process(false)
	var timer = get_tree().create_timer(1)
	await timer.timeout
	$Warning.visible = false
	$TaterTot.visible = true
	$EnemyHurtbox/CollisionShape2D.set_deferred("disabled", false)
	$CollisionShape2D.set_deferred("disabled", false)
	
	set_physics_process(true)

func _physics_process(_delta: float) -> void:
	velocity = speed * (player.global_position - global_position).normalized()
	move_and_slide()



var is_tweening = false
func damaged() -> void:
	if not is_tweening:
		is_tweening = true
		var tween = create_tween()
		tween.set_parallel()
		$TaterTot.material.set_shader_parameter("flash_amount", 0.95)
		tween.tween_property($TaterTot.material, "shader_parameter/flash_amount", 0.7, 0.15)
		await tween.finished
		$TaterTot.material.set_shader_parameter("flash_amount", 0.0)
		is_tweening = false
		
func _on_health_component_died() -> void:
	explode()
	alive = false
var alive = true
var exploding = false
func _on_player_detection_body_entered(_body: Node2D) -> void:
	if not exploding:
		exploding = true
		$TaterTot.play()
		var timer = get_tree().create_timer(2)
		await timer.timeout
		if alive:
			explode()

func explode() -> void:
	$TaterTot.visible = false
	$Explosion.visible = true
	$Explosion.play()
	$EnemyHurtbox/CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)
	if player in $DamageArea.get_overlapping_bodies():
		RunManager.player.health_component.take_damage()
		RunManager.player.health_component.player.apply_force(500, (player.global_position - global_position).normalized())
	await $Explosion.animation_finished
	queue_free()
