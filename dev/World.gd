extends Node3D

@export var RootScene: PackedScene
@export var WaterCollectibleScene: PackedScene
@export var MirrorCollectibleScene: PackedScene
@export var ReflectionScene: PackedScene


var islands = []
@onready var debug_camera = $CameraRotaterY/CameraRotaterX/Camera2
var deployed_mirror = null


func _ready() -> void:
	randomize()
	Globals.connect("start_menu_closed",Callable(self,"on_start_menu_closed"))

	GameEvents.deploy_mirror.connect(deploy_mirror)
	GameEvents.spawn_root.connect(spawn_root)

	var spawns = get_tree().get_nodes_in_group("Collectible_Spawns")
	for s in range(0, spawns.size()):
		match s % 2:
			0:
				var new_collectible = WaterCollectibleScene.instantiate()
				new_collectible.position = spawns[s].global_position
				add_child(new_collectible)
			1:
				var new_collectible = MirrorCollectibleScene.instantiate()
				new_collectible.position = spawns[s].global_position
				new_collectible.Sun = $Sun
				add_child(new_collectible)


func deploy_mirror(pos, target):

	var reflection = ReflectionScene.instantiate()
	add_child(reflection)

	var mirror = MirrorCollectibleScene.instantiate()
	mirror.collectable = false
	mirror.position = pos
	mirror.target = target
	mirror.Reflection = reflection
	add_child(mirror)
	$Camera3D.Target = mirror
	deployed_mirror = mirror


func abort_deploy():
	if deployed_mirror:
		deployed_mirror.collectable = true
		deployed_mirror = null
#	deployed_mirror.Reflection.queue_free()
#	deployed_mirror.queue_free()

	$Player.abort_deploy()
	$Camera3D.Target = $Player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_camera"):
		debug_camera.current = !debug_camera.current
		if !debug_camera.current:
			GameEvents.emit_signal("switch_to_player_cam")

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

#	if Input.is_action_just_pressed("spawn_root"):
#		spawn_root(null, Vector3(75.920403, 29.684401, 46.6586), Vector3(53.641254, 0, -20.974489), null)


func spawn_root(_root_seed, pos, target, target_island):

	# finished with the mirror
	abort_deploy()

	var new_root = RootScene.instantiate()
	new_root.RootCamera = $RootCamera
	add_child(new_root)
	new_root.start_grow(pos, target, target_island)


func _input(event):

	#if event is InputEventKey and event.keycode == KEY_P:
	if Input.is_action_just_pressed("pause"):
		$Menu.visible = true
		Globals.set_is_start_menu(true)
		$AnimationPlayer.play("MenuFadeIn")
		await $AnimationPlayer.animation_finished
		get_tree().paused = true
		pass 


func on_start_menu_closed():
	$AnimationPlayer.play("MenuFadeOut")

	await $AnimationPlayer.animation_finished

	# start things for ingame
	# change camera
	GameEvents.emit_signal("switch_to_player_cam")
	# start engine
	if $Player.electric_gyrocopter_unlocked:
		$Player.blades_sound.play()
	else:
		$Player.motor_sound.play()


	$Menu.visible = false
	var StartButton = $Menu.get_node("ColorRect/StartMenu/CenterContainer/VBoxContainer/StartGame")
	StartButton.text = tr('CONTINUE')
	pass
