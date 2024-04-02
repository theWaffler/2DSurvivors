extends CanvasLayer

@export var arena_time_manager: Node
@onready var label = $%Label

func _process(delta):
	if arena_time_manager == null:
		return

	var time_elpased = arena_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elpased)

func format_seconds_to_string(seconds: float):
	var minutes = floor(seconds/60) # round to nearest int value
	var remaining_seconds = seconds - (minutes * 60)
	return str(minutes) + ":" + ("%02d" % floor(remaining_seconds)) 
