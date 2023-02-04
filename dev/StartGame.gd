extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_focus_mode(true)
	self.connect("pressed", self, "on_pressed")
	pass # Replace with function body.

func on_pressed():
	print('test')
	get_tree().change_scene("res://World.tscn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
