extends Spatial


var RootScene = preload("res://search_root.tscn")


func _unhandled_input(event):

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	if false:#Input.is_action_just_pressed("ui_accept"):
		for i in range(0, 5):
			var new_root = RootScene.instance()
			add_child(new_root)
