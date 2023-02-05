extends CanvasLayer


func _ready() -> void:
	GameEvents.connect("fade_in", $AnimationPlayer, "play", ["fade_in"])
	GameEvents.connect("fade_out", $AnimationPlayer, "play", ["fade_out"])
