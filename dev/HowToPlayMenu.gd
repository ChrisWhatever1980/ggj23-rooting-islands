extends Control

func _ready():
	self.visible = false
	$CenterContainer/HBoxContainer/GamepadButton.visible = false
	$CenterContainer/HBoxContainer/KeyboardButton.visible = true


func _on_KeyboardButton_pressed() -> void:
	$AnimationPlayer.play("show_controls")
	$CenterContainer/HBoxContainer/GamepadButton.visible = true
	$CenterContainer/HBoxContainer/KeyboardButton.visible = false


func _on_GamepadButton_pressed() -> void:
	$AnimationPlayer.play_backwards("show_controls")
	$CenterContainer/HBoxContainer/GamepadButton.visible = false
	$CenterContainer/HBoxContainer/KeyboardButton.visible = true
