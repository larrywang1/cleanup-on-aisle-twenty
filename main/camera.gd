extends Camera2D

@onready var timer : Timer = $Timer
@onready var player = get_tree().get_first_node_in_group("player")
var shake_amount: float = 0
var can_shake : bool = true

func _ready() -> void:
	EventBus.screenshake.connect(shake)

func _process(_delta: float) -> void:
	global_position = player.global_position
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)

func shake(time : float, amount : float) -> void:
	if can_shake:
		timer.wait_time = time
		shake_amount = amount
		timer.start()

func _on_timer_timeout() -> void:
	shake_amount = 0
	
