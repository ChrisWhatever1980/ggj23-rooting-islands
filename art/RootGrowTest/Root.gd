extends Spatial


var RootMeshScene = preload("res://RootMesh.tscn")
var grow = 0.0
var current_root_mesh
var max_depth = 20.0
var depth = 0.0
var speed = 5.0
var grow_direction = Vector3.UP


func _ready():
	randomize()
	current_root_mesh = $RootMesh
	new_segment(current_root_mesh)


func _process(delta):
	if depth < max_depth and grow < 1.0:
		grow += delta * speed
		current_root_mesh.scale = Vector3.ONE * grow
		current_root_mesh.set_top_radius(grow)
		if grow >= 1.0:
			new_segment(current_root_mesh)
			grow = 0.0


func new_segment(root):

	if depth >= max_depth:
		return

	var root_mesh = RootMeshScene.instance()
	add_child(root_mesh)

	# depth:		20		10		0
	# width:		0.2		1		0.2

	# Envelope
	var x = depth / max_depth
	var y = 1.0 - (1.0 - 2 * x) * (1.0 - 2 * x)
	print(str(x) + ", " + str(y))
	var root_width = lerp(0.2, 0.5, y)

	var scale = 1.0# + randf() * 3.0;
	root_mesh.scale.y = scale
	root_mesh.mesh.scale.y = scale
	root_mesh.rotate_x(root_width * (-1.0 * randf() * 2.0))
	root_mesh.rotate_y(2.0 * PI * (-1.0 * randf() * 2.0))
	root.endPos.translation.y *= scale
	root_mesh.translation = root.endPos.global_translation
	root_mesh.scale = Vector3.ZERO
	current_root_mesh = root_mesh
	depth += 1.0
