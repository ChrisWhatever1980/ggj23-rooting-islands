extends KinematicBody


export(NodePath) onready var cam = get_node(cam) as Node
export(PackedScene) var WaterScene


var velocity = Vector3.ZERO
var target_velocity = Vector3.ZERO
var speed = 10.0
var turbo = false
var lerp_velocity_speed = 10.0
var water_gauge_mat
var deploying_mirror = false
var can_fire_water = true
var relatives_found = 0
var nearby_collectibale = null

onready var Gyrocopter = $GyrocopterRotate
onready var motor_sound = $MotorSound


var Water = 0
var Mirrors = 0


func _ready() -> void:
	GameEvents.connect("relative_found", self, "relative_found")


func relative_found():
	relatives_found += 1
	# TODO: show an old family foto and a message


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	var cam_forward = cam.get_camera_forward()
	cam_forward.y = 0.0
	cam_forward = cam_forward.normalized()

	var target_velocity = Vector3.ZERO

	if !deploying_mirror:
		if Input.is_action_pressed("rightstick_forward"):
			target_velocity += cam_forward

		if Input.is_action_pressed("rightstick_backward"):
			target_velocity += -cam_forward

		if Input.is_action_pressed("rightstick_left"):
			target_velocity += -cam_forward.cross(Vector3.UP)

		if Input.is_action_pressed("rightstick_right"):
			target_velocity += cam_forward.cross(Vector3.UP)

		if Input.is_action_pressed("sink"):
			target_velocity += Vector3.DOWN

		if Input.is_action_pressed("rise"):
			target_velocity += Vector3.UP

		if Input.is_action_just_pressed("give_mirror"):
			give_mirror()

		if Input.is_action_just_pressed("give_water"):
			give_water()

		if Input.is_action_just_pressed("deploy_mirror"):
			deploy_mirror()

		if Input.is_action_just_pressed("shoot_water"):
			shoot_water()
			
		if Input.is_action_just_pressed("collect_resource"):
			collect_resource()

		if Input.is_action_pressed("turbo"):
			turbo = true
		else:
			turbo = false

	target_velocity = target_velocity.normalized() * speed

	velocity = lerp(velocity, (4.0 if turbo else 1.0) * target_velocity, 0.03)

	motor_sound.pitch_scale = 1.0 + velocity.length() / 10.0

	if velocity.length_squared() > 0.0:
		var look_direction = velocity
		look_direction.y = 0.0
		look_direction = look_direction.normalized()
		Gyrocopter.look_at(translation + 10 * look_direction, Vector3.UP)

	move_and_slide(velocity)


func deploy_mirror():
	if Mirrors > 0:
		deploying_mirror = true
		GameEvents.emit_signal("deploy_mirror", translation, translation + 5 * transform.basis.z)
		Mirrors -= 1


func shoot_water():
	if Water > 10:
		Water -= 10
		var shootWater = WaterScene.instance()
		shootWater.translation = translation
		shootWater.velocity = -Gyrocopter.global_transform.basis.z
		shootWater.collectable = false
		can_fire_water = false
		get_parent().add_child(shootWater)
		$WaterReloadTimer.start()


func abort_deploy():
	deploying_mirror = false
	give_mirror()


func _on_Area_entered(area: Area) -> void:
	if Water < 100 and area.is_in_group("WaterCollectible"):
		if area.collectable:
			#print("Collectable water close")
			nearby_collectibale = area

	if Mirrors < 5 and area.is_in_group("MirrorCollectible"):
		#print("Collectable mirror close")
		nearby_collectibale = area


func _on_Area_exited(area: Area) -> void:
	if area.is_in_group("WaterCollectible") or area.is_in_group("MirrorCollectible"):
		nearby_collectibale = null


func collect_resource():
	if nearby_collectibale:
		if Water < 100 and nearby_collectibale.is_in_group("WaterCollectible") and nearby_collectibale.collectable:
			give_water()
			nearby_collectibale.queue_free()
			nearby_collectibale = null
			return
		if Mirrors < 5 and nearby_collectibale.is_in_group("MirrorCollectible") and nearby_collectibale.collectable:
			give_mirror()
			nearby_collectibale.Reflection.queue_free()
			nearby_collectibale.queue_free()
			nearby_collectibale = null
			return


func give_water():
	Water += 5 + randi() % 5
	Water = clamp(Water, 0, 100)
	GameEvents.emit_signal("update_water", Water / 100.0)


func give_mirror():
	Mirrors += 1
	print("Mirrors: " + str(Mirrors))
	Mirrors = clamp(Mirrors, 0, 5)
	GameEvents.emit_signal("update_mirror", Mirrors)


func _on_WaterReloadTimer_timeout() -> void:
	can_fire_water = true
