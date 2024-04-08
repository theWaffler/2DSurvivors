extends Node

signal experience_updated(current_exp: float, target_experience: float)
signal level_up(new_level: int)

const TARGET_EXPERIENCE_GROWTH = 5

var current_exp = 0
var current_level = 1
var target_experience = 5

func _ready():
	GameEvents.experience_taco_collected.connect(on_exp_taco_collected)
	

func increment_exp(number: float):
	#urrent_exp += number
	current_exp = min(current_exp + number, target_experience)
	experience_updated.emit(current_exp, target_experience)
	if current_exp == target_experience:
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_exp = 0 # reset current exp
		experience_updated.emit(current_exp, target_experience) # emit updated exp
	#else:
	#	experience_updated.emit(current_exp, target_experience) # emit updated exp if not leveling up
		level_up.emit(current_level)
#signal handler
func on_exp_taco_collected(number: float):
	increment_exp(number)
