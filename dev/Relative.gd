extends Spatial


var waves = 3
onready var mesh = $CharacterMale/Skeleton/characterLargeFemale

func _ready() -> void:
	GameEvents.connect("relative_wave", self, "wave")
	GameEvents.connect("relative_idle", self, "idle")
	idle()


func set_color(color):
	var mat = mesh.get_surface_material(0).duplicate()
	mat.albedo_color = color
	mesh.set_surface_material(0, mat)


func idle():
	$AnimationPlayer.play("modelsIdle")


func walk():
	$AnimationPlayer.play("modelsWalk")


func wave():
	yield(get_tree().create_timer(randf() * 0.5), "timeout")
	$AnimationPlayer.play("wave")
	
	yield(get_tree().create_timer(1.0 + randf() * 2.0), "timeout")
	waves -= 1
	if waves > 0:
		wave()
