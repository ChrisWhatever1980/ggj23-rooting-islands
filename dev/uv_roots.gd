extends Node3D


var grow = 0.0
var sphere_mat
var root_mat

# Called when the node enters the scene tree for the first time.
func _ready():
	sphere_mat = $Sphere002.get_surface_override_material(0)
	root_mat = $Root001.get_surface_override_material(0)


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		grow = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grow < 1.0:
		grow += delta * 0.2
		sphere_mat.set_shader_parameter("grow", grow)
		$Sphere002.position.x = lerp(4.0, -3.305, grow)
		root_mat.set_shader_parameter("grow", grow)
		$Root001.position.x = lerp(7.178, 0.0, grow)

		if grow >= 1.0:
			grow = 1.0
	
