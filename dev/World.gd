extends Spatial


export(PackedScene) var RootScene
export(PackedScene) var WaterCollectibleScene
export(PackedScene) var MirrorCollectibleScene


var islands = []
onready var debug_camera = $CameraRotaterY/CameraRotaterX/Camera2


func _ready() -> void:
	randomize()
	islands = [
		$FloatingIsland,
		$FloatingIsland2,
		$FloatingIsland7,
		$FloatingIsland3,
		$FloatingIsland4,
		$FloatingIsland5,
		$FloatingIsland6
	]
	
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
				add_child(new_collectible)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch_camera"):
		debug_camera.current = !debug_camera.current

	if Input.is_action_just_pressed("spawn_root"):
		islands[randi() % islands.size()]
		spawn_root(islands[rand_range(0, islands.size())], islands[rand_range(0, islands.size())])


func spawn_root(island0, island1):
	var new_root = RootScene.instance()
	add_child(new_root)
	new_root.translation = island0.translation
	new_root.target_scale = island0.translation.distance_to(island1.translation) / 2.0
	new_root.scale.z = 0.0
	new_root.look_at(island1.translation, Vector3.UP)
