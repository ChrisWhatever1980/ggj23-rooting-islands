extends CheckBox

func _ready():
	self.connect("pressed", self, "on_pressed")
	pass

func on_pressed():
	Globals.is_movement_stick_swapped = self.pressed
	pass
