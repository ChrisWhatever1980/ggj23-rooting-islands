extends StaticBody


onready var relativeCamera = $Camera
onready var relative = $Relative
onready var animPlayer = $Camera/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.connect("switch_to_relative_cam", self, "switch_to_relative_cam")


func _process(delta: float) -> void:
	relativeCamera.look_at(relative.global_translation, Vector3.UP)


func switch_to_relative_cam(target_island):
	if Globals.MessageCounter < 6 and self == target_island:
		animPlayer.play("RESET")
		relativeCamera.current = true
		GameEvents.emit_signal("fade_in")
		yield(get_tree().create_timer(1.0), "timeout")
		$Relative.walk()
		animPlayer.play("zoom_anim")
		yield(get_tree().create_timer(2.0), "timeout")
		$Relative.wave()
		yield(get_tree().create_timer(1.067), "timeout")
		# show message
		yield(get_tree().create_timer(1.0), "timeout")

		print("Show Message " + str(Globals.MessageCounter + 1))

		var trigger_happy_end = Globals.MessageCounter + 1 == 6
		GameEvents.emit_signal("show_message", "MESSAGE" + str(Globals.MessageCounter + 1), true, trigger_happy_end)

		Globals.MessageCounter += 1
