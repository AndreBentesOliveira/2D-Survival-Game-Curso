extends CanvasLayer

@export var arena_time_manager: Node
@onready var label = $%Label

var minutes
var remaining_seconds

func _process(delta):
	if arena_time_manager == null:
		return
	var time_elapse = arena_time_manager.get_time_elapsed()
	label.text = format_seconds(time_elapse)


func format_seconds(seconds):
	minutes = floor(seconds / 60)
	remaining_seconds = seconds - (minutes * 60)
	return str(minutes) + ":" + ("%02d" % floor(remaining_seconds))
