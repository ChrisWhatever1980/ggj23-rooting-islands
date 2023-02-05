extends Spatial


func _ready() -> void:
	GameEvents.connect("relative_wave", self, "wave")
	GameEvents.connect("relative_idle", self, "idle")
	idle()


func set_color(color):
	var mat = $CharacterMale/Skeleton/characterLargeFemale.get_surface_material(0)
	mat.albedo_color = color


func idle():
	$AnimationPlayer.play("modelsIdle")


func walk():
	$AnimationPlayer.play("modelsWalk")


func wave():
	$AnimationPlayer.play("wave")
