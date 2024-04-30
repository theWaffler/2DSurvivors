extends Node
class_name HealthComponent

signal died
signal health_changed # signal to change health

@export var max_health: float = 10 # can be changed in the inspector
var current_health

func _ready():
	current_health = max_health

func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0) # no negative health
	health_changed.emit()
	Callable(check_death).call_deferred() # passing ref function

func get_health_percent():
	if max_health <= 0:
		return
	return min(current_health/max_health, 1)

func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free() # releases parent class ownership