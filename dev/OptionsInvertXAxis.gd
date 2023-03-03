extends CheckBox

func _ready():
	self.connect("pressed",Callable(self,"on_pressed"))

func on_pressed():
	Globals.is_x_axis_inverted = self.button_pressed
