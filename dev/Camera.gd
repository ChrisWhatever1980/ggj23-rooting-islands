extends KinematicBody

export var rotate_speed = 1.0
export var lerp_speed = 3.0
export(NodePath) onready var Player = get_node(Player) as Node
export (Vector3) var offset = Vector3.ZERO

onready var Cam = $Camera


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	translation = translation.move_toward(Player.translation, delta)
#	Cam.look_at(Player.translation, Vector3.UP)
	pass


func get_camera_forward():
	return -Cam.transform.basis.z.normalized()


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("leftstick_left"):
		offset = offset.rotated(Vector3.UP, delta * rotate_speed)

	if Input.is_action_pressed("leftstick_right"):
		offset = offset.rotated(Vector3.UP, -delta * rotate_speed)

	var cam_axis = transform.basis.x.normalized()

	if Input.is_action_pressed("leftstick_up"):
		offset = offset.rotated(cam_axis, delta * rotate_speed)

	if Input.is_action_pressed("leftstick_down"):
		offset = offset.rotated(cam_axis, -delta * rotate_speed)

	var target_pos = Player.translation + offset
	
	var velocity = (target_pos - translation)

	move_and_slide(velocity, Vector3.UP)

	Cam.look_at(Player.global_transform.origin, Vector3.UP)