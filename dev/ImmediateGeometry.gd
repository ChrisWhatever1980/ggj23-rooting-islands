extends MeshInstance3D


var sun = Vector3.ZERO
var mirror = Vector3.ZERO
var reflected = Vector3.ZERO
var normal = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)

	mesh.surface_add_vertex(to_local(sun))
	mesh.surface_add_vertex(to_local(mirror))

	mesh.surface_add_vertex(to_local(mirror))
	mesh.surface_add_vertex(to_local(reflected))

	mesh.surface_add_vertex(to_local(mirror))
	mesh.surface_add_vertex(to_local(mirror + 5 * normal))

	mesh.surface_end()
