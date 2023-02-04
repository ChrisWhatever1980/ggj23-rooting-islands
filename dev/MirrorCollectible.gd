extends Area


var Sun = null
var rot_axis
export(NodePath) onready var Spotlight = get_node(Spotlight) as Node
var target = null
var collectable = true
var mirror_mat


func _ready() -> void:
	Sun = get_parent().get_node("Sun")
	rot_axis = Vector3(-1.0 + randf() * 2.0, -1.0 + randf() * 2.0, -1.0 + randf() * 2.0).normalized()
	mirror_mat = $mirror_collectible/Plane.mesh.surface_get_material(0)


func _process(delta: float) -> void:
	if collectable:
		rotate(rot_axis, delta)
	if target:
		translation = translation.move_toward(target, delta)


func _physics_process(delta):
	var light_on = false
	if Sun:
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(translation, Sun.translation, [self])
		if result and result.collider.is_in_group("Sun"):
			var sun_vector = (translation - Sun.translation).normalized()
			var angle = sun_vector.signed_angle_to(global_transform.basis.y, Vector3.UP)
			if angle >= PI * 0.5:
				var mirror_dir = sun_vector.reflect(global_transform.basis.y)
				Spotlight.look_at(translation + mirror_dir, Vector3.UP)
				light_on = true
			else:
				light_on = false
		else:
			light_on = false

	toggle_light(light_on)


func toggle_light(active):
	Spotlight.visible = active
	$SpotlightShine.visible = active
	mirror_mat.emission_enabled = active
