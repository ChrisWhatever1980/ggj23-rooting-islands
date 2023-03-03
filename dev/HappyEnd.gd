extends Node3D


var colors = [Color.BROWN, Color.BURLYWOOD, Color.CHOCOLATE, 
	Color.DARK_SLATE_BLUE, Color.GOLD, Color.HOT_PINK, 
	Color.DARK_SLATE_GRAY, Color.SEA_GREEN]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	GameEvents.show_happy_end.connect(show_happy_end)
	$Relative1.set_color(colors[0])
	$Relative2.set_color(colors[1])
	$Relative3.set_color(colors[2])
	$Relative4.set_color(colors[3])
	$Relative5.set_color(colors[4])
	$Relative6.set_color(colors[5])
	$Relative7.set_color(colors[6])
	$Relative8.set_color(colors[7])


func show_happy_end():
	await get_tree().create_timer(1.0).timeout
	visible = true
	$HappyEndCamera.current = true
	GameEvents.emit_signal("fade_in")
	GameEvents.emit_signal("relative_wave")
	await get_tree().create_timer(2.0).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
