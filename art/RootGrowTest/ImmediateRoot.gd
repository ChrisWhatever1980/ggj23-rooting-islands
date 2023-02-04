extends ImmediateGeometry


var noise = OpenSimplexNoise.new()
var depth = 0
var max_depth = 2

var start_pos = Vector3.ZERO
var end_pos = Vector3.ZERO


func _ready():

	# Configure
	randomize()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8

	clear()
	end_pos = Vector3.ZERO
	grow_dirs.append(Vector3(0.1, 1.0, 0.1).normalized())
	grow()


func grow():
	var root_width = 0.4
	start_pos = end_pos
	end_pos = start_pos + (Vector3.UP + Vector3(-root_width + randf() * 2 * root_width, 0.0, -root_width + randf() * 2 * root_width)).normalized()
	#end_pos = start_pos + Vector3(0.1, 1.0, 0.1).normalized()
	create_segment()

	depth += 1
	if depth < max_depth:
		grow()


func _process(_delta):
	# Clean up before drawing.
	pass
	#clear()
	#create_segment()

var grow_dirs = []
var vertices = []

func create_segment():
	# Begin draw.
	begin(Mesh.PRIMITIVE_TRIANGLES)

	var end_grow_dir = (end_pos - start_pos).normalized()
	print("Start: " + str(end_grow_dir))
	var start_grow_dir = grow_dirs[grow_dirs.size() - 1]
	print("End:   " + str(start_grow_dir))
	grow_dirs.append(end_grow_dir)

	var sides = 16
	for i in range(0, sides):

		var angle0 = deg2rad(i * (360.0 / sides))
		var angle1 = deg2rad((i+1) * (360.0 / sides))
		var start_radius = 1.0
		var end_radius = 1.0

		var start_xaxis = start_grow_dir.cross(Vector3.UP).normalized()
		var start_yaxis = start_grow_dir.cross(start_xaxis).normalized()

		var end_xaxis = end_grow_dir.cross(Vector3.UP).normalized()
		var end_yaxis = end_grow_dir.cross(end_xaxis).normalized()

#		add_vertex(start_pos + end_yaxis * cos(angle0) * start_radius + end_xaxis * sin(angle0) * start_radius)
#		add_vertex(start_pos + end_yaxis * cos(angle1) * start_radius + end_xaxis * sin(angle1) * start_radius)
#		add_vertex(start_pos)

		# Sides
#		add_vertex(start_pos + start_yaxis * cos(angle0) * start_radius + start_xaxis * sin(angle0) * start_radius)
#		add_vertex(start_pos + start_yaxis * cos(angle1) * start_radius + start_xaxis * sin(angle1) * start_radius)
#		add_vertex(end_pos + end_yaxis * cos(angle1) * end_radius + end_xaxis * sin(angle1) * end_radius)
#
#		add_vertex(start_pos + start_yaxis * cos(angle0) * start_radius + start_xaxis * sin(angle0) * start_radius)
#		add_vertex(end_pos + end_yaxis * cos(angle1) * end_radius + end_xaxis * sin(angle1) * end_radius)
#		add_vertex(end_pos + end_yaxis * cos(angle0) * end_radius + end_xaxis * sin(angle0) * end_radius)

		var v1 = start_pos + start_yaxis * cos(angle0) * start_radius + start_xaxis * sin(angle0) * start_radius
		var v2 = start_pos + start_yaxis * cos(angle1) * start_radius + start_xaxis * sin(angle1) * start_radius
		var v3 = end_pos + end_yaxis * cos(angle1) * end_radius + end_xaxis * sin(angle1) * end_radius
		var v4 = end_pos + end_yaxis * cos(angle0) * end_radius + end_xaxis * sin(angle0) * end_radius

		add_vertex(v1)
		add_vertex(v2)
		add_vertex(v2 + end_grow_dir)

		add_vertex(v1)
		add_vertex(v2 + end_grow_dir)
		add_vertex(v1 + end_grow_dir)


	# End drawing.
	end()







