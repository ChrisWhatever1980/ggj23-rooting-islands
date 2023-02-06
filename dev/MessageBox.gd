extends CenterContainer


func _ready() -> void:
	GameEvents.connect("show_message", self, "show_message")


func show_message(msg, fadeout):
	$ColorRect/Label.text = tr(msg)
	visible = true
	$AnimationPlayer.play("show_message_anim")
	yield(get_tree().create_timer(10.0), "timeout")
	$AnimationPlayer.play("hide_message_anim")
	yield(get_tree().create_timer(1.0), "timeout")
	if fadeout:
		GameEvents.emit_signal("fade_out")
	yield(get_tree().create_timer(1.0), "timeout")
	visible = false
	GameEvents.emit_signal("switch_to_player_cam")
	if fadeout:
		GameEvents.emit_signal("fade_in")
