extends KinematicBody

export var rotate_speed = 1.0
export var lerp_speed = 3.0
export(NodePath) onready var Target = get_node(Target) as Node
export (Vector3) var offset = Vector3.ZERO

onready var Cam = $Camera


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	translation = translation.move_toward(Target.translation, delta)
#	Cam.look_at(Target.translation, Vector3.UP)
	pass


func get_camera_forward():
	return -Cam.transform.basis.z.normalized()


func _physics_process(delta: float) -> void:
	var x_inversion = 1
	if Globals.is_x_axis_inverted: x_inversion = -1
	
	var y_inversion = 1
	if Globals.is_y_axis_inverted: y_inversion = -1
	
	var stick_position := "left"
	var forward_action := "up"
	var backward_action := "down"

	if Globals.is_movement_stick_swapped: 
		stick_position = "right"
		forward_action = "forward"
		backward_action = "backward"

	if Input.is_action_pressed(stick_position + "stick_left"):
		offset = offset.rotated(Vector3.UP, delta * rotate_speed * x_inversion)

	if Input.is_action_pressed(stick_position + "stick_right"):
		offset = offset.rotated(Vector3.UP, -delta * rotate_speed * x_inversion)

	var cam_axis = transform.basis.x.normalized()

	if Input.is_action_pressed(stick_position + "stick_" + forward_action):
		offset = offset.rotated(cam_axis, delta * rotate_speed * y_inversion)

	if Input.is_action_pressed(stick_position + "stick_" + backward_action):
		offset = offset.rotated(cam_axis, -delta * rotate_speed * y_inversion)

	var target_pos = Target.translation + offset
	
	var velocity = (target_pos - translation)

	move_and_slide(velocity, Vector3.UP)

	Cam.look_at(Target.global_transform.origin, Vector3.UP)
