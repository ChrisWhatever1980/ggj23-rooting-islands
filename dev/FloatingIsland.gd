extends StaticBody3D


@onready var relativeCamera = $Camera
@onready var relative = $Relative
@onready var animPlayer = $Camera/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.switch_to_relative_cam.connect(switch_to_relative_cam)


func _process(_delta: float) -> void:
	relativeCamera.look_at(relative.global_position, Vector3.UP)


func switch_to_relative_cam(target_island):
	if Globals.MessageCounter < 6 and self == target_island:
		animPlayer.play("RESET")
		relativeCamera.current = true
		GameEvents.emit_signal("fade_in")
		await get_tree().create_timer(1.0).timeout
		$Relative.walk()
		animPlayer.play("zoom_anim")
		await get_tree().create_timer(2.0).timeout
		$Relative.wave()
		await get_tree().create_timer(1.067).timeout
		# show message
		await get_tree().create_timer(1.0).timeout

		print("Show Message " + str(Globals.MessageCounter + 1))

		var trigger_happy_end = Globals.MessageCounter + 1 == 6
		GameEvents.emit_signal("show_message", "MESSAGE" + str(Globals.MessageCounter + 1), true, trigger_happy_end)

		Globals.MessageCounter += 1
