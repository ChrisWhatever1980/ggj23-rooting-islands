extends OptionButton

const languages := {
	0: 'de',
	1: 'en'
}

func _ready():
	self.connect("item_selected",Callable(self,"on_selected"))
	var current_language = TranslationServer.get_locale()
	
	for i in languages:
		if languages[i] == current_language: self.selected = 1

func on_selected(selected_index):
	TranslationServer.set_locale(languages[selected_index])
