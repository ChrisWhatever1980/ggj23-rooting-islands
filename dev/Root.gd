extends KinematicBody


var stopped = false
var grow = 0.0
var grow_target
var target_length = 0.0
var root_mat
var dryness = 0.0
var RootCamera
var target_island

export var grow_time = 30.0
export var dryout_time = 30.0


func _ready() -> void:
	root_mat = $MeshInstance.get_surface_material(0)


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

	yield(get_tree().create_timer(1.0), "timeout")



func _process(delta: float) -> void:
#	dryness += delta * (1.0 / dryout_time)
#	root_mat.albedo_color = lerp(Color.tan, Color.black, dryness)
#	if dryness >= 1.0:
#		queue_free()

	var mesh_height = $MeshInstance.mesh.height

	var anim_speed = 0.1
	if !stopped and grow < 1.0:
		grow += delta * anim_speed

		$MeshInstance.mesh.height = lerp(2.0, target_length, grow)
		$CollisionShape.shape.height = lerp(2.0, target_length, grow)

		$MeshInstance.translation.z = lerp(-1, -target_length / 2.0, grow)
		$CollisionShape.translation.z = lerp(-1, -target_length / 2.0, grow)

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

