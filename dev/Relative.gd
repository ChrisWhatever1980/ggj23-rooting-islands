extends Node3D


var waves = 3
@onready var mesh = $CharacterMale/Skeleton3D/characterLargeFemale

func _ready() -> void:
	GameEvents.relative_wave.connect(wave)
	GameEvents.relative_idle.connect(idle)
	idle()


func set_color(color):
	var mat = mesh.get_surface_override_material(0).duplicate()
	mat.albedo_color = color
	mesh.set_surface_override_material(0, mat)


func idle():
	$AnimationPlayer.play("Idle")


func walk():
	$AnimationPlayer.play("Walk")


func wave():
	await get_tree().create_timer(randf() * 0.5).timeout
	$AnimationPlayer.play("wave")
	
	await get_tree().create_timer(1.0 + randf() * 2.0).timeout
	waves -= 1
	if waves > 0:
		wave()
