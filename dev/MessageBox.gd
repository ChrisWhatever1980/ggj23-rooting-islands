extends CenterContainer


func _ready() -> void:
	GameEvents.show_message.connect(show_message)


func show_message(msg, fadeout, trigger_happy_end):
	$ColorRect/Label.text = tr(msg)
	$AnimationPlayer.play("RESET")
	visible = true
	$AnimationPlayer.play("show_message_anim")
	await get_tree().create_timer(10.0).timeout
	$AnimationPlayer.play("hide_message_anim")
	await get_tree().create_timer(0.5).timeout
	if fadeout:
		GameEvents.emit_signal("fade_out")
	await get_tree().create_timer(0.5).timeout
	visible = false
	
	if !trigger_happy_end:
		GameEvents.emit_signal("switch_to_player_cam")
		if fadeout:
			GameEvents.emit_signal("fade_in")
	else:
		# happy end after the message
		GameEvents.emit_signal("show_happy_end")
		await get_tree().create_timer(0.5).timeout
		GameEvents.emit_signal("unlock_electric_gyrocopter")
		GameEvents.emit_signal("show_message", "NEW_RIDE_MSG", false, false)
