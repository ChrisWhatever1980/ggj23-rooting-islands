extends KinematicBody


var stopped = false
var grow = 0.0
var target_scale = 0.0
var root_mat
var dryness = 0.0


export var grow_time = 30.0
export var dryout_time = 30.0


func _ready() -> void:
	root_mat = $MeshInstance.get_surface_material(0)


func _process(delta: float) -> void:
	dryness += delta * (1.0 / dryout_time)
	root_mat.albedo_color = lerp(Color.tan, Color.black, dryness)
	if dryness >= 1.0:
		queue_free()

	if !stopped and grow < 1.0:
		grow += delta * (1.0 / grow_time)
		scale.z = lerp(scale.z, target_scale, grow)
		if grow >= 1.0:
			stopped = true
