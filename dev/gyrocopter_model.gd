extends Node3D


@onready var waterLevelScale = $WaterTank/WaterLevelScale


func _ready() -> void:
	GameEvents.update_water.connect(set_water_level)
	GameEvents.update_mirror.connect(set_mirror_count)


func set_water_level(level):
	print("Water Level: " + str(level))
	waterLevelScale.scale.y = lerp(0.0, 0.75, level)


func set_mirror_count(count):
	print("set_mirror_count: " + str(count))
	for i in range(0, 5):
		get_node("mirror_collectible" + str(i)).visible = i < count
