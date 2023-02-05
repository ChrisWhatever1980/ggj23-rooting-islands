extends Area


var growing = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	# raycast to sun and mirrors
	var light_check = false

	# raycast to water
	var water_check = false
	var water_pos = Vector3.ZERO

	var water = null
	var light = null

	var water_light_targets = get_tree().get_nodes_in_group("Water_and_Light")
	for lt in water_light_targets:
		if lt.is_in_group("Water_collectable"):
			if !lt.viable_root_target:
				continue
		if lt.is_in_group("Sun") or lt.is_in_group("MirrorCollectible"):
			if !lt.light_on:
				continue

		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(translation, lt.translation, [self], 0x7FFFFFFF, true, true)

		if result.size() > 0:
			if result.collider.is_in_group("Islands"):
				continue
			if result.collider == lt:
				if result.collider.is_in_group("WaterCollectible"):
					water_check = true
					water = lt
					water_pos = lt.translation
				if result.collider.is_in_group("Sun"):
					#print(self.name + " viable target: " + lt.name)
					light = lt
					light_check = true
				if result.collider.is_in_group("MirrorCollectible"):
					light = lt
					light_check = true

	if water_check and light_check:
		# water is present
		# light is present: does light hit seed?
		var light_hits_seed = false
		if light.is_in_group("MirrorCollectible"):
			var light_vector = -light.Reflection.global_transform.basis.z
			var source_vector = (translation - light.translation).normalized()
			var light_angle = light_vector.angle_to(source_vector)
			if light_angle < deg2rad(5.0):
				light_hits_seed = true
		else:
			light_hits_seed = true	# from the sun
		
		if light_hits_seed and !growing:
			print("Valid " + self.name + " sprouts: " + water.name + ", " + light.name)
			GameEvents.emit_signal("spawn_root", self, translation, water_pos, water.target_island)
			growing = true
