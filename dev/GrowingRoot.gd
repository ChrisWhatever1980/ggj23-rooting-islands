extends KinematicBody


var stopped = false
var grow = 0.0
var grow_target
var target_length = 0.0
var root_mat
var dryness = 0.0
var RootCamera
var target_island
var growing_root_mat


onready var root_grow_sound = $root_grow_sound
onready var growing_root1 = $roots/Root001
onready var growing_root2 = $roots/Root002


export var grow_time = 30.0
export var dryout_time = 30.0


func _ready() -> void:
	root_mat = $MeshInstance.get_surface_material(0)
	growing_root_mat = growing_root1.get_surface_material(0).duplicate()
	growing_root1.set_surface_material(0, growing_root_mat)
	growing_root2.set_surface_material(0, growing_root_mat)

func start_grow(pos, target, island):
	target_island = island

	var to_target = target - pos
	translation = pos - to_target * 0.1
	grow_target = target + to_target * 0.1

	target_length = grow_target.distance_to(translation)
	look_at(grow_target, Vector3.UP)

	RootCamera.translation = translation + Vector3(20, 0, -20)
	RootCamera.look_at(translation, Vector3.UP)
	RootCamera.current = true
	
	$RootSoundTimer.start()

	yield(get_tree().create_timer(1.0), "timeout")



func _process(delta: float) -> void:

	var anim_speed = 0.1
	if !stopped and grow < 1.0:
		grow += delta * anim_speed

#		$MeshInstance.mesh.height = lerp(2.0, target_length, grow)
#		$MeshInstance.translation.z = lerp(-1, -target_length / 2.0, grow)

		$CollisionShape.shape.height = lerp(2.0, target_length, grow)
		$CollisionShape.translation.z = lerp(-1, -target_length / 2.0, grow)

		$MeshInstance.mesh.height = target_length
		$CollisionShape.shape.height = target_length

		$roots.scale.x = target_length / 7.0

		growing_root_mat.set_shader_param("grow", grow)
		$roots.translation.z = lerp(target_length * 0.9, 0.0, grow)

		var cam_target = lerp(translation, grow_target, 0.5)
		RootCamera.translation = lerp(translation, cam_target, grow) + Vector3(20, 0, -20)

		#print(str(grow))

		var lookat = lerp(translation, grow_target, grow)
		RootCamera.look_at(lookat, Vector3.UP)

		if grow >= 1.0:
			stopped = true

			GameEvents.emit_signal("fade_out")

			yield(get_tree().create_timer(0.5), "timeout")

			GameEvents.emit_signal("switch_to_relative_cam", target_island)


func _on_RootSoundTimer_timeout() -> void:
	if !stopped and !root_grow_sound.playing:
		root_grow_sound.play()
	if stopped:
		$RootSoundTimer.stop()
