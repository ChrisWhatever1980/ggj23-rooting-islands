extends Button

func _ready():
	self.connect("pressed", self, "on_pressed")

func on_pressed():
	get_node("../../..").visible = false
	var test = get_node("../../../../OptionsMenu")
	test.visible = true
