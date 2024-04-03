extends Node

var current_exp = 0

func _ready():
	GameEvents.experience_taco_collected.connect(on_exp_taco_collected)
	

func increment_exp(number: float):
	current_exp += number
	print(current_exp)

#signal handler
func on_exp_taco_collected(number: float):
	increment_exp(number)
