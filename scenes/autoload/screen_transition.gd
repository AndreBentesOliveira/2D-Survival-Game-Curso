extends CanvasLayer
 
signal transitioned_halfway
 
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func transition_in():
	$ColorRect.visible = true
	animation_player.play("default")
	await animation_player.animation_finished
	transitioned_halfway.emit()
	animation_player.play_backwards("default")
	await animation_player.animation_finished
	$ColorRect.visible = false


func transition_to_scene(scene_path: String):
	transition_in()
	await transitioned_halfway
	get_tree().change_scene_to_file(scene_path)
