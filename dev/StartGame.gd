extends Button


func _ready():
	self.grab_focus()
	pressed.connect(on_pressed)


func on_pressed():
	Globals.set_is_start_menu(false)
	get_tree().paused = false
