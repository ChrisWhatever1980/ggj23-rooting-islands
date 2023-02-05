extends Spatial

export(PackedScene) var RootScene
export(PackedScene) var WaterCollectibleScene
export(PackedScene) var MirrorCollectibleScene


var islands = []
onready var debug_camera = $CameraRotaterY/CameraRotaterX/Camera2
var deployed_mirror = null


func _ready() -> void:
	randomize()

	$MirrorCollectible.Sun = $Sun
	Globals.connect("start_menu_closed", self, "on_start_menu_closed")
	
	GameEvents.connect("deploy_mirror", self, "deploy_mirror")

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


func deploy_mirror(pos, target):
	var mirror = MirrorCollectibleScene.instance()
	mirror.translation = pos
	mirror.target = target
	mirror.collectable = false
	add_child(mirror)
	$Camera.Target = mirror
	deployed_mirror = mirror


func abort_deploy():
	deployed_mirror.queue_free()
	deployed_mirror = null
	$Player.abort_deploy()
	$Camera.Target = $Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_camera"):
		debug_camera.current = !debug_camera.current

	if Input.is_action_just_pressed("spawn_root"):
		islands[randi() % islands.size()] 
		spawn_root(islands[rand_range(0, islands.size())], islands[rand_range(0, islands.size())])

	if deployed_mirror:
		var x_axis = deployed_mirror.transform.basis.x
		if Input.is_action_pressed("rightstick_forward"):
			deployed_mirror.rotate(x_axis, delta)

		if Input.is_action_pressed("rightstick_backward"):
			deployed_mirror.rotate(x_axis, -delta)

		if Input.is_action_pressed("rightstick_left"):
			deployed_mirror.rotate_y(-delta)

		if Input.is_action_pressed("rightstick_right"):
			deployed_mirror.rotate_y(delta)
			
		if Input.is_action_just_pressed("abort_deploy"):
			abort_deploy()


func spawn_root(island0, island1):
	var new_root = RootScene.instance()
	add_child(new_root)
	new_root.translation = island0.translation
	new_root.target_scale = island0.translation.distance_to(island1.translation) / 2.0
	new_root.scale.z = 0.0
	new_root.look_at(island1.translation, Vector3.UP)

func _input(event):
	if event is InputEventKey and  event.scancode == KEY_P:
		$Menu.visible = true;
		$AnimationPlayer.play("MenuFadeIn")
		yield ($AnimationPlayer, "animation_finished")
		get_tree().paused = true
		pass 

	
func on_start_menu_closed():
	$AnimationPlayer.connect("finished", self, "after_menu_fade_out_animation")
	$AnimationPlayer.play("MenuFadeOut")

	yield ($AnimationPlayer, "animation_finished")

	$Menu.visible = false
	var StartButton = $Menu.get_node("ColorRect/StartMenu/CenterContainer/VBoxContainer/StartGame")
	StartButton.text = 'Continue'
	pass
