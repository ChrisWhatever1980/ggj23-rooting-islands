extends KinematicBody


export(NodePath) onready var cam = get_node(cam) as Node


var velocity = Vector3.ZERO
var target_velocity = Vector3.ZERO
var speed = 10.0
var lerp_velocity_speed = 10.0
var water_gauge_mat
var deploying_mirror = false


onready var Gyrocopter = $GyrocopterRotate
onready var motor_sound = $MotorSound

var Water = 0
var Mirrors = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	var cam_forward = cam.get_camera_forward()

	var target_velocity = Vector3.ZERO

	if !deploying_mirror:
		if Input.is_action_pressed("rightstick_forward"):
			target_velocity = cam_forward * speed

		if Input.is_action_pressed("rightstick_backward"):
			target_velocity = -cam_forward * speed

		if Input.is_action_pressed("rightstick_left"):
			target_velocity = -cam_forward.cross(Vector3.UP) * speed

		if Input.is_action_pressed("rightstick_right"):
			target_velocity = cam_forward.cross(Vector3.UP) * speed

		if Input.is_action_just_pressed("give_mirror"):
			give_mirror()

		if Input.is_action_just_pressed("give_water"):
			give_water()

		if Input.is_action_just_pressed("deploy_mirror"):
			deploy_mirror()

		if Input.is_action_just_pressed("shoot_water"):
			shoot_water()

	velocity = lerp(velocity, target_velocity, 0.03)

	motor_sound.pitch_scale = 1.0 + velocity.length() / 10.0

	if velocity.length_squared() > 0.0:
		Gyrocopter.look_at(translation + 10 * velocity, Vector3.UP)

	move_and_slide(velocity)


func deploy_mirror():
	if Mirrors > 0:
		deploying_mirror = true
		GameEvents.emit_signal("deploy_mirror", translation, translation + 5 * transform.basis.z)
		Mirrors -= 1


func shoot_water():
	pass


func abort_deploy():
	deploying_mirror = false
	give_mirror()


func _on_Area_entered(area: Area) -> void:
	if Water < 100 and area.is_in_group("WaterCollectible"):
		give_water()
		area.queue_free()
	if Mirrors < 5 and area.is_in_group("MirrorCollectible") and area.collectable:
		give_mirror()
		area.queue_free()


func give_water():
	Water += 5 + randi() % 5
	Water = clamp(Water, 0, 100)
	GameEvents.emit_signal("update_water", Water / 100.0)


func give_mirror():
	Mirrors += 1
	print("Mirrors: " + str(Mirrors))
	Mirrors = clamp(Mirrors, 0, 5)
	GameEvents.emit_signal("update_mirror", Mirrors)
