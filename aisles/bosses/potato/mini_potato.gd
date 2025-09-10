extends CharacterBody2D

var shader = preload("res://miscellaneous/enemy_flash.tres")
func _ready() -> void:
	$Sprite2D.material = shader.duplicate()

var is_tweening = false
func damaged() -> void:
	if $"../../Potato".state == $"../../Potato".states.INACTIVE:
		$"../../Potato".first_damaged()
	if not is_tweening:
		is_tweening = true
		var tween = create_tween()
		tween.set_parallel()
		$Sprite2D.material.set_shader_parameter("flash_amount", 0.95)
		tween.tween_property($Sprite2D.material, "shader_parameter/flash_amount", 0.7, 0.15)
		await tween.finished
		$Sprite2D.material.set_shader_parameter("flash_amount", 0.0)
		is_tweening = false
func _on_health_component_died() -> void:
	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$EnemyHurtbox/CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()
	$Timer2.start()
	$Timer3.stop()

func _on_timer_timeout() -> void:
	$GPUParticles2D.emitting = false
	$Sprite2D.visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	$EnemyHurtbox/CollisionShape2D.set_deferred("disabled", false)
	$HealthComponent._ready()
	init()

func _on_timer_2_timeout() -> void:
	$GPUParticles2D.emitting = true

func init() -> void:
	fire()
	$Timer3.start()
var pellet = preload("res://aisles/bosses/potato/potato_pellet.tscn")
func fire() -> void:
	var init_dir = randf_range(0, 2 * PI)
	for i in range(3):
		var pellet_instance = pellet.instantiate()
		pellet_instance.direction = Vector2(cos(init_dir + (PI * 2 / 3 * i)), sin(init_dir + (PI * 2 / 3 * i)))
		call_deferred("add_child", pellet_instance)


func _on_timer_3_timeout() -> void:
	fire()
