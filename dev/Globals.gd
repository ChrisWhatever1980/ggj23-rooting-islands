extends Node

var is_start_menu := true : set = set_is_start_menu
var is_x_axis_inverted := false
var is_y_axis_inverted := false
var is_movement_stick_swapped := false

var MessageCounter = 0

signal start_menu_closed

func set_is_start_menu(new_value):
	is_start_menu = new_value
	if (!new_value):
		emit_signal("start_menu_closed")
