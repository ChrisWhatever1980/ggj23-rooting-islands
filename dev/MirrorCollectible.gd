extends Area


var Sun = null
var rot_axis
var target = null
var collectable = true
var mirror_mat
var light_on = false
export(NodePath) var ReflectionPath = null
var Reflection = null


func _ready() -> void:
	if ReflectionPath != null:
		Reflection = get_node(ReflectionPath) as Node
	Sun = get_parent().get_node("Sun")
	rot_axis = Vector3(-1.0 + randf() * 2.0, -1.0 + randf() * 2.0, -1.0 + randf() * 2.0).normalized()
	mirror_mat = $Plane.mesh.surface_get_material(0)


func _process(delta: float) -> void:
	if collectable:
		rotate(rot_axis, delta)
	if target:
		translation = translation.move_toward(target, delta)


func _physics_process(delta):
	if !Reflection:
		print_debug("ERROR: Reflection missing")

	light_on = false
	if Sun:
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(translation, Sun.translation, [self])
		if result:
			if result.collider.is_in_group("Sun"):
				var sun_vector = (global_translation - Sun.translation).normalized()
				var mirror_dir = -global_transform.basis.z.normalized()
				var angle = sun_vector.signed_angle_to(mirror_dir, Vector3.UP)
				#print(str(rad2deg(angle)))
				if !(angle >= -PI / 2.0 and angle <= PI / 2.0):
					var reflect_dir = -sun_vector.reflect(mirror_dir)
					Reflection.look_at_from_position(global_translation, global_translation + 5.0 * reflect_dir, Vector3.UP)
					light_on = true

#	var sun_vector1 = (global_translation - Sun.translation).normalized()
#	var mirror_vector = -global_transform.basis.z.normalized()
#	var reflect_dir = sun_vector1.reflect(mirror_vector)
#	$ImmediateGeometry.reflected = global_translation + 5.0 * reflect_dir
#	$ImmediateGeometry.normal = -global_transform.basis.z

	if Reflection:
		Reflection.visible = light_on
		mirror_mat.emission_enabled = light_on
	
