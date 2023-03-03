extends CanvasLayer


func _ready() -> void:
	GameEvents.fade_in.connect(Callable($AnimationPlayer,"play").bind("fade_in"))
	GameEvents.fade_out.connect(Callable($AnimationPlayer,"play").bind("fade_out"))
