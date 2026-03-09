extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")
var hand_cursor = load("res://assets/tile_0134.png")


func _ready():
	Input.set_custom_mouse_cursor(hand_cursor, Input.CURSOR_POINTING_HAND, Vector2(0, 0))
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$%Player.health_component.died.connect(on_player_died)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()


func on_player_died():
	
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.get_node("%MaxTimeLabel").text = $ArenaTimeUI.format_seconds($ArenaTimeManager.get_time_elapsed())
	end_screen_instance.set_defeat()
	
	var max_time = $ArenaTimeManager.get_time_elapsed()
	var max_enemy_killed = GameEvents.enemys_killed
	var max_level = GameEvents.current_player_level
	check_new_hight_score(max_time, max_enemy_killed, max_level, end_screen_instance)
	
	MetaProgression.save()


func check_new_hight_score(max_time, max_enemy_killed, max_level, end_screen):
	if GameEvents.enemys_killed > MetaProgression.save_data["enemys_kill"]:
		MetaProgression.save_data["enemys_kill"] = GameEvents.enemys_killed
		end_screen.kill_record_label.show()
		
	if GameEvents.current_player_level > MetaProgression.save_data["level"]:
		MetaProgression.save_data["level"] = GameEvents.current_player_level
		end_screen.level_record_label.show()
	
	if $ArenaTimeManager.get_time_elapsed() > MetaProgression.save_data["time"]:
		MetaProgression.save_data["time"] = $ArenaTimeManager.get_time_elapsed()
		end_screen.time_record_label.show()
	MetaProgression.save()
