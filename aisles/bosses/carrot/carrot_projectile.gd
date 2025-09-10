extends Area2D

@export var speed : int
var behavior : behaviors
enum behaviors {
	RANDOM,
	TRACK,
	TRAIL
}
var target_position : Vector2
var direction : Vector2
var trail : bool = false

func _on_start_time_timeout() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
	$Projectile.visible = true
	$Warning.visible = false
	if behavior == behaviors.RANDOM:
		target()
	if behavior == behaviors.TRACK:
		track()
	if behavior == behaviors.TRAIL:
		target()
		trail = true

func _on_area_entered(_area: Area2D) -> void:
	get_tree().get_first_node_in_group("player_health").take_damage()
	queue_free()

func _ready() -> void:
	set_process(false)
	
func track() -> void:
	set_process(true)
	$Timer.start()

func _process(_delta: float) -> void:
	look_at(get_tree().get_first_node_in_group("player").global_position)

func target() -> void:
	var tween = create_tween()
	tween.tween_property(self, "rotation", get_angle_to(target_position), 1)
	await tween.finished
	direction = (target_position - global_position).normalized()
	fire()

func fire() -> void:
	set_physics_process(true)
	if trail:
		$TrailTimer.start()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_life_time_timeout() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	set_process(false)
	direction = (get_tree().get_first_node_in_group("player").global_position - global_position).normalized()

var baby_carrot = preload("res://aisles/bosses/carrot/baby_carrot.tscn")
func _on_trail_timer_timeout() -> void:
	var baby_carrot_instance = baby_carrot.instantiate()
	baby_carrot_instance.rotation = rotation
	baby_carrot_instance.global_position = global_position
	get_tree().get_first_node_in_group("projectiles").add_child(baby_carrot_instance)
