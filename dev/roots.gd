extends Spatial


var grow = 0.0
var mat;
onready var root_mesh = $Root001

# Called when the node enters the scene tree for the first time.
func _ready():
	mat = root_mesh.get_surface_material(0)


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		grow = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grow < 1.0:
		grow += delta * 0.2
		mat.set_shader_param("grow", grow)
		root_mesh.translation.x = lerp(4.0, -3.305, grow)
		if grow >= 1.0:
			grow = 1.0
	
