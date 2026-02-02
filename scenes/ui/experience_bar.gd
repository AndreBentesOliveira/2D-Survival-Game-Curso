extends CanvasLayer

@export var experience_manager : Node
@onready var progress_bar = $MarginContainer/ProgressBar

func _ready():
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experince_updated)


func on_experince_updated(current_experince: float, target_experience: float):
	var percent = current_experince / target_experience
	progress_bar.value = percent
