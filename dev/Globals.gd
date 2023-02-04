extends Node

var is_start_menu := true setget set_is_start_menu

signal start_menu_closed

func set_is_start_menu(new_value):
	is_start_menu = new_value
	if (!new_value):
		emit_signal("start_menu_closed")
		pass
