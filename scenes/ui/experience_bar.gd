extends CanvasLayer

@export var experience_manager: Node
@onready var progress_bar = $MarginContainer/ProgressBar

func _ready():
    progress_bar.value = 0
    experience_manager.experience_updated.connect(on_experience_updated)

func on_experience_updated(current_exp: float, target_experience: float):
    if target_experience == 0:
        return
    
    #progress_bar.max_value = target_experience # update max value of progress bar
    var percent: float = current_exp / target_experience
    #progress_bar.value = percent * progress_bar.max_value # update display value
    progress_bar.value = percent