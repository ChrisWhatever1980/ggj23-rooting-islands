extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.connect("update_mirror", self, "update_mirror")
	GameEvents.connect("update_water", self, "update_water")


func update_mirror(mirrors):
	$VBoxContainer/MirrorsLabel.text = "Mirrors: " + str(mirrors)


func update_water(water):
	$VBoxContainer/WaterLabel.text = "Water: " + str(water)
