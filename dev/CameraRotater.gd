extends Node3D


var mouse_move = Vector2.ZERO


func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_move = event.relative
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				$CameraRotaterX/Camera2.position *= 0.9
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				$CameraRotaterX/Camera2.position *= 1.1


func _process(delta):
	rotate_y(mouse_move.x * delta)
	$CameraRotaterX.rotate_x(-mouse_move.y * delta)
	mouse_move = Vector2.ZERO
