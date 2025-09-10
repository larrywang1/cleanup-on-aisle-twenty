extends CharacterBody2D

@export var marker1 : Marker2D
@export var marker2 : Marker2D
@export var marker3 : Marker2D
@export var arrow : Sprite2D
@export var sprite2 : Sprite2D 
@export var particle : GPUParticles2D
func _ready() -> void:
	pass

func pierce() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", marker2.position, 0.2)
	tween.tween_property(self, "position", marker1.position, 1.2)

func outer(a) -> void:
	arrow.visible = true
	var timer = get_tree().create_timer(1)
	await timer.timeout
	arrow.visible = false
	if a:
		var tween = create_tween()
		tween.tween_property(self, "position", marker2.position, 0.2)
	else:
		var tween = create_tween()
		tween.tween_property(self, "position", marker3.position, 0.2)
	$"../Timers/SpinTimer".start()
	await $"../Timers/SpinTimer".timeout
	var ween = create_tween()
	ween.tween_property(self, "position", marker1.position, 0.2)
		

func _on_health_component_died() -> void:
	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$EnemyHitbox/CollisionShape2D2.set_deferred("disabled", true)
	$EnemyHurtbox/CollisionShape2D2.set_deferred("disabled", true)
	$Timer.start()
	$Timer2.start()

func _on_timer_timeout() -> void:
	$GPUParticles2D.emitting = false
	$Sprite2D.visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	$EnemyHitbox/CollisionShape2D2.set_deferred("disabled", false)
	$EnemyHurtbox/CollisionShape2D2.set_deferred("disabled", false)
	$HealthComponent._ready()

var is_tweening = false
func damaged() -> void:
	if $"../../Potato".state == $"../../Potato".states.INACTIVE:
		$"../../Potato".first_damaged()
	if not is_tweening:
		is_tweening = true
		var tween = create_tween()
		tween.set_parallel()
		sprite2.material.set_shader_parameter("flash_amount", 0.95)
		tween.tween_property(sprite2.material, "shader_parameter/flash_amount", 0.7, 0.15)
		await tween.finished
		sprite2.material.set_shader_parameter("flash_amount", 0.0)
		is_tweening = false

func _on_timer_2_timeout() -> void:
	$GPUParticles2D.emitting = true
