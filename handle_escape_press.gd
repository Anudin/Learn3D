extends Node

func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		var is_mouse_captured : bool = Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
		
		Input.set_mouse_mode(
			Input.MOUSE_MODE_VISIBLE if is_mouse_captured else Input.MOUSE_MODE_CAPTURED)