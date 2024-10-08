extends Control

@export var health_container : HBoxContainer
var health_node := preload("res://ui/hud/health_ui.tscn")
var max_health : int = 0
var current_health : int = 0
var health_nodes : Array = []

@export var stamina_container : HBoxContainer
var stamina_node := preload("res://ui/hud/stamina_ui.tscn")
var max_stamina : int = 0
var current_stamina : int = 0
var stamina_nodes : Array = []

func _ready():
	EventBus.add_health.connect(add_health)
	EventBus.restore_health.connect(restore_health)
	EventBus.lose_health.connect(lose_health)
	EventBus.remove_health.connect(remove_health)
	
	EventBus.add_stamina.connect(add_stamina)
	EventBus.restore_stamina.connect(restore_stamina)
	EventBus.lose_stamina.connect(lose_stamina)
	EventBus.remove_stamina.connect(remove_stamina)


func add_health():
	var health_instance = health_node.instantiate()
	health_nodes.append(health_instance)
	max_health += 1
	current_health += 1
	if current_health < max_health:
		health_instance.lost_health()
		health_nodes[current_health - 1].restore_health()
	health_container.add_child(health_instance)
	

func restore_health():
	if current_health < max_health:
		health_nodes[current_health].restore_health()
		current_health += 1
	

func lose_health():
	if current_health > 0:
		current_health -= 1
		health_nodes[current_health].lost_health()

func remove_health():
	health_container.remove_child(health_nodes[max_health - 1])
	if current_health == max_health:
		current_health -= 1
	max_health -= 1

func add_stamina():
	var stamina_instance = stamina_node.instantiate()
	stamina_nodes.append(stamina_instance)
	max_stamina += 1
	current_stamina += 1
	if current_stamina < max_stamina:
		stamina_instance.lost_stamina()
		stamina_nodes[current_stamina - 1].restore_stamina()
	stamina_container.add_child(stamina_instance)
	

func restore_stamina():
	if current_stamina < max_stamina:
		stamina_nodes[current_stamina].restore_stamina()
		current_stamina += 1
	

func lose_stamina():
	if current_stamina > 0:
		current_stamina -= 1
		stamina_nodes[current_stamina].lost_stamina()

func remove_stamina():
	stamina_container.remove_child(stamina_nodes[max_stamina - 1])
	if current_stamina == max_stamina:
		current_stamina -= 1
	max_stamina -= 1
