extends Area


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(Vector3(-1.0 + randf() * 2.0, -1.0 + randf() * 2.0, -1.0 + randf() * 2.0).normalized(), delta)
