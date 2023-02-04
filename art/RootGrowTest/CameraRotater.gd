extends Spatial


var mouse_move = Vector2.ZERO


func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(BUTTON_LEFT):
		mouse_move = event.relative
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				$CameraRotaterX/Camera.translation *= 0.9
			if event.button_index == BUTTON_WHEEL_DOWN:
				$CameraRotaterX/Camera.translation *= 1.1


func _process(delta):
	rotate_y(mouse_move.x * delta)
	$CameraRotaterX.rotate_x(-mouse_move.y * delta)
	mouse_move = Vector2.ZERO
