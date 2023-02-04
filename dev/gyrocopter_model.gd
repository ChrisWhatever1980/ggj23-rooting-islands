extends Spatial


onready var waterLevelScale = $WaterTank/WaterLevelScale


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.connect("update_water", self, "set_water_level")


func set_water_level(level):
	print("Water Level: " + str(level))
	waterLevelScale.scale.y = lerp(0.0, 0.75, level)
