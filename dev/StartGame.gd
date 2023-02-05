extends Button

func _ready():
	self.grab_focus()
	self.connect("pressed", self, "on_pressed")

func on_pressed():
	Globals.set_is_start_menu(false)
	get_tree().paused = false
