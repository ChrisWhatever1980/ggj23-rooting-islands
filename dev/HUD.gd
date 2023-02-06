extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


func update_mirror(mirrors):
	$VBoxContainer/MirrorsLabel.text = "Mirrors: " + str(mirrors)


func update_water(water):
	$VBoxContainer/WaterLabel.text = "Water: " + str(water)
