extends Area


var hitting_seed = false


func set_enabled(enable):
	print(" toggle collision shape")
	visible = enable
	$CollisionShape.disabled = !enable


func _on_Reflection_area_entered(area: Area) -> void:
	if visible and area.is_in_group("SeedCollectable"):
		hitting_seed = true


func _on_Reflection_area_exited(area: Area) -> void:
	if visible and area.is_in_group("SeedCollectable"):
		hitting_seed = false
