extends Area3D


@export(NodePath) onready var current_island = get_node(current_island) as Node


var growing = false
var water = null
var light = null
var receiving_light_time = 0.0
var exclude_player
var exclude_camera

func _ready():
	exclude_player = get_parent().get_node("Player")
	exclude_camera = get_parent().get_node("Camera3D")


func _physics_process(delta: float) -> void:

	if growing:
		return

	var water_distance = 10000.0

	var water_check = false
	var light_check = false

	var water_light_targets = get_tree().get_nodes_in_group("Water_and_Light")
	for lt in water_light_targets:
		if lt.is_in_group("WaterCollectible"):
			if (!lt.viable_root_target and !lt.shot_by_player) or lt.target_island == current_island:
				continue
			else:
				var seed_water_distance = lt.position.distance_to(position)
				if seed_water_distance < water_distance:
					water_distance = seed_water_distance
					water = lt
					water_check = true

		if lt.is_in_group("Sun") or lt.is_in_group("MirrorCollectible"):
			if !lt.light_on:
				continue

		var space_state = get_world_3d().direct_space_state
		var result = space_state.intersect_ray(position, lt.position, [self, exclude_camera, exclude_player], 0x7FFFFFFF, true, true)

		if result.size() > 0:
			if result.collider.is_in_group("Islands"):
				continue
			if result.collider == lt:
				if result.collider.is_in_group("Sun") or result.collider.is_in_group("MirrorCollectible"):
					light = lt
					light_check = true

	# water has become unavailable
	if !water_check:
		water = null

	# light has become unavailable
	if !light_check:
		light = null
		receiving_light_time = 0.0

	#print(name + ": water " + str(water_check) + ", light " + str(light_check))

	if water and light:
		# water is present
		# light is present: does light hit seed?
			var light_hits_seed = false
			if light.is_in_group("MirrorCollectible"):
				#print(name + " has viable light source: " + light.name)
				var light_vector = -light.Reflection.global_transform.basis.z
				var source_vector = (position - light.position).normalized()
				var light_angle = light_vector.angle_to(source_vector)
				if light_angle < deg_to_rad(5.0):
					light_hits_seed = true
			else:
				light_hits_seed = true	# from the sun

			if light_hits_seed:
				receiving_light_time += delta
				if receiving_light_time >= 1.0:
					print("Valid " + self.name + " sprouts: " + water.name + ", " + light.name)
					GameEvents.emit_signal("spawn_root", self, position, water.position, water.target_island)
					growing = true
			else:
				receiving_light_time = 0.0
	#print("Light3D received: " + str(receiving_light_time))
