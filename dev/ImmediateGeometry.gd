extends ImmediateGeometry


var sun = Vector3.ZERO
var mirror = Vector3.ZERO
var reflected = Vector3.ZERO
var normal = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	clear()
	begin(Mesh.PRIMITIVE_LINES)

	add_vertex(to_local(sun))
	add_vertex(to_local(mirror))

	add_vertex(to_local(mirror))
	add_vertex(to_local(reflected))

	add_vertex(to_local(mirror))
	add_vertex(to_local(mirror + 5 * normal))

	end()
