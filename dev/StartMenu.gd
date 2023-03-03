extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_game_pressed():
	pass # Replace with function body.


func _on_how_to_play_pressed():
	pass # Replace with function body.


func _on_options_pressed():
	pass # Replace with function body.


func _on_credits_pressed():
	visible = false
	get_node("../CreditsMenu").visible = true


func _on_exit_pressed():
	get_tree().quit()
