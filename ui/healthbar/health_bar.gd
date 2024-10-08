extends TextureProgressBar

@onready var timer : Timer = $Timer
@onready var damage_bar : TextureProgressBar = $DamageBar

var health = 0

func _ready() -> void:
	EventBus.boss_spawned.connect(init_health)
	EventBus.boss_health_changed.connect(take_damage)

func init_health(_health : float) -> void:
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func take_damage(damage : float) -> void:
	health -= damage
	value = health
	timer.start()

func _on_timer_timeout() -> void:
	damage_bar.value = health
