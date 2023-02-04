extends Spatial


var mouse_move = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:

	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	if event is InputEventMouseMotion:
		mouse_move = event.relative


func _process(delta: float) -> void:
		rotate_y(mouse_move.x * delta)
		var cam_axis = $CameraRotaterX/Camera2.transform.basis.x
		$CameraRotaterX.rotate(cam_axis, mouse_move.y * delta)
		mouse_move = Vector2.ZERO
