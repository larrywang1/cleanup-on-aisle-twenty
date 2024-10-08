extends CanvasLayer

@onready var animation_player : AnimationPlayer = $AnimationPlayer
var animation : String

func _ready() -> void:
	animation_player.current_animation = animation
	
func finished() -> void:
	EventBus.cutscene_finished.emit()
	queue_free()
