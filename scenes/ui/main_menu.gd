extends CanvasLayer

var option_scene = preload("res://scenes/ui/options_menu.tscn")


func _ready() -> void:
	$%PlayButton.pressed.connect(on_playbutton_pressed)
	$%UpgradesButton.pressed.connect(on_upgradesbutton_pressed)
	$%OptionsButton.pressed.connect(on_optionsbutton_pressed)
	$%QuitButton.pressed.connect(on_quitbutton_pressed)
	
	%MaxLevelLabel.text = str(MetaProgression.save_data["level"])
	%MaxKillLabel.text = str(MetaProgression.save_data["enemys_kill"])
	%MaxTimeLabel.text = str(format_seconds(MetaProgression.save_data["time"]))


func format_seconds(seconds):
	var minutes = floor(seconds / 60)
	var remaining_seconds = seconds - (minutes * 60)
	return str(minutes) + ":" + ("%02d" % floor(remaining_seconds))


func on_playbutton_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func on_upgradesbutton_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")


func on_optionsbutton_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transitioned_halfway
	var options_instance = option_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_close.bind(options_instance))


func on_quitbutton_pressed():
	get_tree().quit()


func on_options_close(options_instance: Node):
	options_instance.queue_free()
