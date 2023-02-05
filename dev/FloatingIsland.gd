extends StaticBody


onready var relativeCamera = $Camera
onready var relative = $House3/Relative
onready var animPlayer = $Camera/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.connect("switch_to_relative_cam", self, "switch_to_relative_cam")


func switch_to_relative_cam(target_island):
	#print("Relative on island " + target_island.name)
	if self == target_island:
		relativeCamera.look_at(relative.global_translation, Vector3.UP)
		relativeCamera.current = true
		GameEvents.emit_signal("fade_in")
		yield(get_tree().create_timer(1.0), "timeout")
		animPlayer.play("zoom_anim")
		# show message
		yield(get_tree().create_timer(2.0), "timeout")
		print("hello Love, where in the world did you find this?")
		yield(get_tree().create_timer(1.0), "timeout")
		print("Oh dear, I miss her so much..")
		yield(get_tree().create_timer(1.0), "timeout")
		GameEvents.emit_signal("fade_out")
		yield(get_tree().create_timer(1.0), "timeout")
		GameEvents.emit_signal("switch_to_player_cam")
		yield(get_tree().create_timer(1.0), "timeout")
		GameEvents.emit_signal("fade_in")
