extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "on_pressed")
	pass # Replace with function body.


func on_pressed():
	get_node("../../..").visible = false
	var test = get_node("../../../../OptionsMenu")
	test.visible = true
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
