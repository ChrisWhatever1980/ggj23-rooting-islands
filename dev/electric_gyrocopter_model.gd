extends Spatial


onready var waterLevelScale = $WaterTank001/WaterLevelScale


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.connect("update_water", self, "set_water_level")
	GameEvents.connect("update_mirror", self, "set_mirror_count")


func set_water_level(level):
	print("Water Level: " + str(level))
	waterLevelScale.scale.y = lerp(0.0, 0.75, level)


func set_mirror_count(count):
	print("set_mirror_count: " + str(count))
	for i in range(0, 5):
		get_node("mirror_collectible" + str(i)).visible = i < count
	
