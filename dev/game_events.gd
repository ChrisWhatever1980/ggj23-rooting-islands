extends Node


signal update_mirror
signal update_water
signal deploy_mirror


func connect(_signal: String, target: Object, method: String, binds: Array = [  ], flags: int = 0):
		var result = .connect(_signal, target, method, binds, flags)
		if result != OK:
			push_error("Cannot connect signal " + _signal + " to " + target.name + "." + method + "()")
