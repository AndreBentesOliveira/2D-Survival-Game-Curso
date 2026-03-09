extends CanvasLayer

@onready var panel_container = $%PanelContainer

@onready var level_record_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MaxLevelHContainer/LevelRecordLabel
@onready var kill_record_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MaxKillsHContainer2/KillRecordLabel
@onready var time_record_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MaxTimeHContainer3/TimeRecordLabel




func _ready():
	level_record_label.hide()
	kill_record_label.hide()
	time_record_label.hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	get_tree().paused = true
	$%ContinueButton.pressed.connect(on_continue_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)


func set_defeat():
	$%TitleLabel.text = "Defeat"
	$%DscriptionLabel.text = "You Lost"
	%MaxLevelLabel.text = str(GameEvents.current_player_level)
	%MaxKillLabel.text = str(GameEvents.enemys_killed)
	
	play_jingle(true)


func play_jingle(defeat: bool = false):
	if defeat:
		$DefeatStremPlayer.play()
	else:
		$VictoryStremPlayer.play()
	

func on_continue_button_pressed():
	ScreenTransition.transition_in()
	await ScreenTransition.transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")


func on_quit_button_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")
	get_tree().paused = false
