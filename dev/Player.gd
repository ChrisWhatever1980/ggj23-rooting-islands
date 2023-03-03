extends CharacterBody3D


@export(NodePath) onready var cam = get_node(cam) as Node
@export var WaterScene: PackedScene


var velocity = Vector3.ZERO
var target_velocity = Vector3.ZERO
var speed = 10.0
var turbo = false
var lerp_velocity_speed = 10.0
var water_gauge_mat
var deploying_mirror = false
var can_fire_water = true
var nearby_collectibale = null

var electric_gyrocopter_unlocked = false

var relatives_found = 0

@onready var Gyrocopter = $GyrocopterRotate
@onready var motor_sound = $MotorSound
@onready var blades_sound = $BladesSound
@onready var waterdrop_sound = $WaterdropSound


var Water = 0
var Mirrors = 0


func _ready() -> void:
	GameEvents.unlock_electric_gyrocopter.connect(unlock_electric_gyrocopter)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	var cam_forward = cam.get_camera_forward()
	cam_forward.y = 0.0
	cam_forward = cam_forward.normalized()

	var target_velocity = Vector3.ZERO
	
	var stick_position := "right"
	var forward_action := "forward"
	var backward_action := "backward"
	if Globals.is_movement_stick_swapped:
		stick_position = "left"
		forward_action = "up"
		backward_action = "down"

	if !deploying_mirror && !Globals.is_start_menu:
		if Input.is_action_pressed(stick_position + "stick_" + forward_action):
			target_velocity += cam_forward

		if Input.is_action_pressed(stick_position + "stick_" + backward_action):
			target_velocity += -cam_forward

		if Input.is_action_pressed(stick_position + "stick_left"):
			target_velocity += -cam_forward.cross(Vector3.UP)

		if Input.is_action_pressed(stick_position + "stick_right"):
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
			
		if Input.is_action_just_pressed("gas_gyrocopter"):
			motor_sound.playing = true
			blades_sound.stop()
			$GyrocopterRotate/electric_gyrocopter.visible = false
			$GyrocopterRotate/Gyrocopter.visible = true
			$GyrocopterRotate/old_gyrocopter.visible = false
			
		if Input.is_action_just_pressed("electric_gyrocopter"):
			motor_sound.stop()
			blades_sound.playing = true
			$GyrocopterRotate/electric_gyrocopter.visible = true
			$GyrocopterRotate/Gyrocopter.visible = false
			$GyrocopterRotate/old_gyrocopter.visible = false
			
		if Input.is_action_just_pressed("old_gyrocopter"):
			motor_sound.stop()
			blades_sound.stop()
			$GyrocopterRotate/electric_gyrocopter.visible = false
			$GyrocopterRotate/Gyrocopter.visible = false
			$GyrocopterRotate/old_gyrocopter.visible = true
		
		if Input.is_action_just_pressed("unlock_electric_gyrocopter"):
			unlock_electric_gyrocopter()

		if Input.is_action_pressed("turbo"):
			turbo = true
		else:
			turbo = false

	target_velocity = target_velocity.normalized() * speed

	velocity = lerp(velocity, (4.0 if turbo else 1.0) * target_velocity, 0.03)

	motor_sound.pitch_scale = 1.0 + velocity.length() / 10.0
	blades_sound.pitch_scale = 1.0 + velocity.length() / 10.0

	if velocity.length_squared() > 0.0:
		var look_direction = velocity
		look_direction.y = 0.0
		look_direction = look_direction.normalized()
		if look_direction.length_squared() > 0.0:
			Gyrocopter.look_at(position + 10 * look_direction, Vector3.UP)

	set_velocity(velocity)
	move_and_slide()


func unlock_electric_gyrocopter():

	if electric_gyrocopter_unlocked:
		return

	electric_gyrocopter_unlocked = true
	motor_sound.stop()
	blades_sound.playing = true
	$GyrocopterRotate/electric_gyrocopter.visible = true
	$GyrocopterRotate/Gyrocopter.visible = false
	$GyrocopterRotate/old_gyrocopter.visible = false


func deploy_mirror():
	if Mirrors > 0:
		deploying_mirror = true
		GameEvents.emit_signal("deploy_mirror", position, position + 5 * transform.basis.z)
		Mirrors -= 1
		GameEvents.emit_signal("update_mirror", Mirrors)


func shoot_water():
	if Water > 10:
		Water -= 10
		var shootWater = WaterScene.instantiate()
		shootWater.position = position
		shootWater.velocity = -Gyrocopter.global_transform.basis.z
		shootWater.collectable = false
		shootWater.shot_by_player = true
		can_fire_water = false
		get_parent().add_child(shootWater)
		shootWater.water_sound.play()
		$WaterReloadTimer.start()
		GameEvents.emit_signal("update_water", Water / 100.0)


func abort_deploy():
	deploying_mirror = false
	#give_mirror()


func _on_Area_entered(area: Area3D) -> void:
	if Water < 100 and area.is_in_group("WaterCollectible"):
		if area.collectable:
			#print("Collectable water close")
			nearby_collectibale = area

	if Mirrors < 5 and area.is_in_group("MirrorCollectible"):
		#print("Collectable mirror close")
		nearby_collectibale = area


func _on_Area_exited(area: Area3D) -> void:
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
	waterdrop_sound.play()


func give_mirror():
	Mirrors += 1
	print("Mirrors: " + str(Mirrors))
	Mirrors = clamp(Mirrors, 0, 5)
	GameEvents.emit_signal("update_mirror", Mirrors)


func _on_WaterReloadTimer_timeout() -> void:
	can_fire_water = true
