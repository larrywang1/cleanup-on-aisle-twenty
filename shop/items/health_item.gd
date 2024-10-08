extends Item
class_name HealthItem


@export var effect : effects
@export var strength : int
@export var lifespan : int
@export var permanent : bool
@export var instant : bool
@export var per_aisle : bool

enum effects {
	MAX_HEALTH,
	CURRENT_HEALTH
}

func add_effect() -> void:
	if effect == effects.MAX_HEALTH:
		for i in range(strength):
			EventBus.add_health.emit()
	if effect == effects.CURRENT_HEALTH:
		for i in range(strength):
			EventBus.restore_health.emit()

func remove_effect() -> void:
	if effect == effects.MAX_HEALTH:
		for i in range(strength):
			EventBus.remove_health.emit()

func purchased() -> void:
	add_effect()
	if instant:
		item_manager.remove_item(self)

func reduce_lifespan() -> void:
	if per_aisle:
		add_effect()
	if not permanent:
		lifespan -= 1
		if lifespan == 0:
			remove_effect()
			item_manager.remove_item(self)
