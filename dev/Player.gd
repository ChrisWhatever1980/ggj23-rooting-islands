extends KinematicBody


export(NodePath) onready var cam = get_node(cam) as Node


var velocity = Vector3.ZERO
var target_velocity = Vector3.ZERO
var speed = 10.0
var lerp_velocity_speed = 10.0
var water_gauge_mat


onready var Gyrocopter = $GyrocopterRotate


var Water = 0
var Mirrors = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	var cam_forward = cam.get_camera_forward()

	var target_velocity = Vector3.ZERO

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

	velocity = lerp(velocity, target_velocity, 0.03)

	if velocity.length_squared() > 0.0:
		print("Velocity: " + str(velocity.length_squared()))
		Gyrocopter.look_at(translation + velocity, Vector3.UP)

	move_and_slide(velocity)


func set_mirror_amount(amount):
#	for m in range(0, 5):
#		get_node("MirrorHolder/Mirror" + str(m)).visible = m <= amount
	GameEvents.emit_signal("update_mirror", amount)


func set_water_level(level):
#	Gauge.scale.z = level / 100.0
	GameEvents.emit_signal("update_water", level / 100.0)


func _on_Area_entered(area: Area) -> void:
	if Water < 100 and area.is_in_group("WaterCollectible"):
		give_water()
		area.queue_free()
	if Mirrors < 5 and area.is_in_group("MirrorCollectible"):
		give_mirror()
		area.queue_free()


func give_water():
	Water += 5 + randi() % 5
	Water = clamp(Water, 0, 100)
	set_water_level(Water)


func give_mirror():
	Mirrors += 1
	Mirrors = clamp(Water, 0, 5)
	set_mirror_amount(Mirrors)
