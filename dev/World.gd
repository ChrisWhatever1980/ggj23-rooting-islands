extends Spatial

export(PackedScene) var RootScene
export(PackedScene) var WaterCollectibleScene
export(PackedScene) var MirrorCollectibleScene
export(PackedScene) var ReflectionScene


var islands = []
onready var debug_camera = $CameraRotaterY/CameraRotaterX/Camera2
var deployed_mirror = null


func _ready() -> void:
	randomize()
	Globals.connect("start_menu_closed", self, "on_start_menu_closed")
	
	GameEvents.connect("deploy_mirror", self, "deploy_mirror")
	GameEvents.connect("spawn_root", self, "spawn_root")
	GameEvents.connect("relative_found", self, "relative_found")

	var spawns = get_tree().get_nodes_in_group("Collectible_Spawns")
	for s in range(0, spawns.size()):
		match s % 2:
			0:
				var new_collectible = WaterCollectibleScene.instance()
				new_collectible.translation = spawns[s].global_translation
				add_child(new_collectible)
			1:
				var new_collectible = MirrorCollectibleScene.instance()
				new_collectible.translation = spawns[s].global_translation
				new_collectible.Sun = $Sun
				add_child(new_collectible)


func relative_found():
	# Show an old family foto and a message
	pass


func deploy_mirror(pos, target):

	var reflection = ReflectionScene.instance()
	add_child(reflection)

	var mirror = MirrorCollectibleScene.instance()
	mirror.collectable = false
	mirror.translation = pos
	mirror.target = target
	mirror.Reflection = reflection
	add_child(mirror)
	$Camera.Target = mirror
	deployed_mirror = mirror


func abort_deploy():
	deployed_mirror.collectable = true
	deployed_mirror = null
#	deployed_mirror.Reflection.queue_free()
#	deployed_mirror.queue_free()

	$Player.abort_deploy()
	$Camera.Target = $Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_camera"):
		debug_camera.current = !debug_camera.current

	if deployed_mirror:
		var x_axis = deployed_mirror.transform.basis.x
		if Input.is_action_pressed("rightstick_forward"):
			deployed_mirror.rotate(x_axis, delta)

		if Input.is_action_pressed("rightstick_backward"):
			deployed_mirror.rotate(x_axis, -delta)

		if Input.is_action_pressed("rightstick_left"):
			deployed_mirror.rotate_y(delta)

		if Input.is_action_pressed("rightstick_right"):
			deployed_mirror.rotate_y(-delta)

		if Input.is_action_just_pressed("abort_deploy"):
			abort_deploy()

	if Input.is_action_just_pressed("spawn_root"):
		spawn_root(null, Vector3(75.920403, 29.684401, 46.6586), Vector3(53.641254, 0, -20.974489), null)


func spawn_root(root_seed, pos, target, target_island):

	if root_seed:
		root_seed.queue_free()

	var new_root = RootScene.instance()
	new_root.RootCamera = $RootCamera
	add_child(new_root)
	new_root.start_grow(pos, target, target_island)

func _input(event):
	if event is InputEventKey and  event.scancode == KEY_P:
		$Menu.visible = true;
		$AnimationPlayer.play("MenuFadeIn")
		yield ($AnimationPlayer, "animation_finished")
		get_tree().paused = true
		pass 

	
func on_start_menu_closed():
	#$AnimationPlayer.connect("animation_finished", self, "after_menu_fade_out_animation")
	$AnimationPlayer.play("MenuFadeOut")

	yield ($AnimationPlayer, "animation_finished")

	$Menu.visible = false
	var StartButton = $Menu.get_node("ColorRect/StartMenu/CenterContainer/VBoxContainer/StartGame")
	StartButton.text = 'Continue'
	pass
