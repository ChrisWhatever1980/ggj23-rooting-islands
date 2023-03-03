extends Button

func _ready():
	self.pressed.connect(on_pressed)

func on_pressed():
	get_node("../../..").visible = false
	var test = get_node("../../../../OptionsMenu")
	test.visible = true
