extends ToolButton

func _ready():
	self.connect("pressed", self, "on_pressed")

func on_pressed():
	get_node("../../..").visible = false
	get_node("../../../../StartMenu").visible = true
