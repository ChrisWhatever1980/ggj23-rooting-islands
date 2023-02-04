extends Spatial


onready var endPos = $EndPos
onready var mesh = $MeshInstance


# Called when the node enters the scene tree for the first time.
func _ready():
	mesh.mesh = mesh.mesh.duplicate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_top_radius(radius):
	mesh.mesh.top_radius = radius


func set_bottom_radius(radius):
	mesh.mesh.bottom_radius = radius
