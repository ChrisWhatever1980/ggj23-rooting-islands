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
	new_segment()


func _process(delta):
	if depth < max_depth and grow < 1.0:
		grow += delta * speed
		if grow >= 1.0:
			new_segment()
			grow -= 1.0


func new_segment():

	if depth >= max_depth:
		return


	# depth:		20		10		0
	# width:		0.2		1		0.2

	# Envelope
	var x = depth / max_depth
	var y = 1.0 - (1.0 - 2 * x) * (1.0 - 2 * x)
	var root_radius = 1.0#lerp(0.2, 0.5, y)
	
	# get new point inside cylinder
	var rand_vec = Vector3(-root_radius + randf() * 2 * root_radius, 0.0, -root_radius + randf() * 2 * root_radius)
	var grow_length = (grow_direction + rand_vec).length()
	var new_point = current_root_mesh.global_translation + grow_direction + rand_vec

	# create segment
	var root_mesh = RootMeshScene.instance()
	add_child(root_mesh)
	root_mesh.look_at_from_position(current_root_mesh.endPos.global_translation, new_point, Vector3.UP)
	root_mesh.endPos.translation = new_point
	current_root_mesh = root_mesh
	depth += 1.0











