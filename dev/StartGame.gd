extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.grab_focus()
	self.connect("pressed", self, "on_pressed")
	pass # Replace with function body.

func on_pressed():
	Globals.set_is_start_menu(false)
	get_tree().paused = false
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
