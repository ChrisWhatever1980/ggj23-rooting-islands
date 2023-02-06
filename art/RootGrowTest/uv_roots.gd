extends Spatial


var grow = 0.0
var mat;

# Called when the node enters the scene tree for the first time.
func _ready():
	mat = $Sphere002.get_surface_material(0)


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		grow = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grow < 1.0:
		grow += delta * 0.2
		mat.set_shader_param("grow", grow)
		$Sphere002.translation.x = lerp(4.0, -3.305, grow)
		if grow >= 1.0:
			grow = 1.0
	
