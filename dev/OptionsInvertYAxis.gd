extends CheckBox

func _ready():
	self.connect("pressed", self, "on_pressed")

func on_pressed():
	Globals.is_y_axis_inverted = self.pressed
