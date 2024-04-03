extends Node

signal experience_taco_collected(number: float)

func emit_experience_taco_collected(number: float):
	experience_taco_collected.emit(number)
