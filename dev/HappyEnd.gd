extends Spatial


var colors = [Color.brown, Color.burlywood, Color.chocolate, 
	Color.darkslateblue, Color.gold, Color.hotpink, 
	Color.darkslategray, Color.seagreen]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	GameEvents.connect("show_happy_end", self, "show_happy_end")
	$Relative1.set_color(colors[0])
	$Relative2.set_color(colors[1])
	$Relative3.set_color(colors[2])
	$Relative4.set_color(colors[3])
	$Relative5.set_color(colors[4])
	$Relative6.set_color(colors[5])
	$Relative7.set_color(colors[6])
	$Relative8.set_color(colors[7])


func show_happy_end():
	yield(get_tree().create_timer(1.0), "timeout")
	visible = true
	$HappyEndCamera.current = true
	GameEvents.emit_signal("fade_in")
	GameEvents.emit_signal("relative_wave")
	yield(get_tree().create_timer(2.0), "timeout")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
