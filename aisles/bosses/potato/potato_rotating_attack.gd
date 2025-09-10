extends Node2D
@export var rotation_speed :float

func _ready() -> void:
	set_physics_process(false)

func start() -> void:
	set_physics_process(true)
	pierce()
	$Timers/AttackTimer.start()
var state = true

func _physics_process(delta: float) -> void:
	rotation += rotation_speed * delta

var first = true
func pierce() -> void:
	start_pierce($FrenchFry, $FrenchFry5)
	$Timers/PierceTimer.start()
	await $Timers/PierceTimer.timeout
	start_pierce($FrenchFry4, $FrenchFry3)
	$Timers/PierceTimer.start()
	await $Timers/PierceTimer.timeout
	start_pierce($FrenchFry2, $FrenchFry6)
	$Timers/PierceTimer.start()
	await $Timers/PierceTimer.timeout
	if first:
		pierce()
		first = false
	
	
func start_pierce(fry1, fry2) -> void:
	fry1.arrow.visible = true
	fry2.arrow.visible = true
	$Timers/PiercePrepareTimer.start()
	await $Timers/PiercePrepareTimer.timeout
	fry1.arrow.visible = false
	fry2.arrow.visible = false
	fry1.pierce()
	fry2.pierce()

@onready var fries = [$FrenchFry, $FrenchFry2, $FrenchFry3, $FrenchFry4, $FrenchFry5, $FrenchFry6]
var rand = true
func _on_attack_timer_timeout() -> void:
	if state:
		rand = not rand
		for fry in fries:
			fry.outer(rand)
	else:
		first = true
		pierce()
	state = not state
