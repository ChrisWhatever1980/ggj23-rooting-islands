extends Area


var Sun = null
var rot_axis
export(NodePath) onready var Spotlight = get_node(Spotlight) as Node


func _ready() -> void:
	rot_axis = Vector3(-1.0 + randf() * 2.0, -1.0 + randf() * 2.0, -1.0 + randf() * 2.0).normalized()


func _process(delta: float) -> void:
	rotate(rot_axis, delta)


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
