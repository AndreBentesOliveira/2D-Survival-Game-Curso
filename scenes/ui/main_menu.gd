extends CanvasLayer

var option_scene = preload("res://scenes/ui/options_menu.tscn")


func _ready() -> void:
	$%PlayButton.pressed.connect(on_playbutton_pressed)
	$%OptionsButton.pressed.connect(on_optionsbutton_pressed)
	$%QuitButton.pressed.connect(on_quitbutton_pressed)


func on_playbutton_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/main.tscn")


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
