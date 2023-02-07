extends Node


signal fade_in
signal fade_out
signal update_water
signal update_mirror
signal deploy_mirror
signal spawn_root
signal unlock_electric_gyrocopter
signal switch_to_player_cam
signal switch_to_relative_cam
signal show_message
signal relative_wave
signal relative_idle
signal show_happy_end


func connect(_signal: String, target: Object, method: String, binds: Array = [  ], flags: int = 0):
		var result = .connect(_signal, target, method, binds, flags)
		if result != OK:
			push_error("Cannot connect signal " + _signal + " to " + target.name + "." + method + "()")
