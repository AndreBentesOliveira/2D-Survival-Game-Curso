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
	end_screen_instance.set_defeat()
	MetaProgression.save()
