extends OptionButton

const languages := {
	0: 'de',
	1: 'en'
}

func _ready():
	self.connect("item_selected", self, "on_selected")

func on_selected(selected_index):
	TranslationServer.set_locale(languages[selected_index])
