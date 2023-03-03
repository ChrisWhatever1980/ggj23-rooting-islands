extends Node3D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$WaterCollectible.viable_root_target = true
	$MirrorCollectible.collectable = false
	$MirrorCollectible.Sun = $Sun


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$MirrorCollectible/ImmediateMesh.sun = $Sun.position
	$MirrorCollectible/ImmediateMesh.mirror = $MirrorCollectible.position

	var deployed_mirror = $MirrorCollectible
	var x_axis = deployed_mirror.transform.basis.x
	if Input.is_action_pressed("rightstick_forward"):
		deployed_mirror.rotate(x_axis, delta)

	if Input.is_action_pressed("rightstick_backward"):
		deployed_mirror.rotate(x_axis, -delta)

	if Input.is_action_pressed("rightstick_left"):
		deployed_mirror.rotate_y(delta)

	if Input.is_action_pressed("rightstick_right"):
		deployed_mirror.rotate_y(-delta)
