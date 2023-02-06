extends Area


var speed = 10.0
var collectable = true
var velocity = Vector3.ZERO
var viable_root_target = false
var target_island


onready var water_sound = $water_sound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$WaterStopTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	translation += velocity * speed * delta


func _on_WaterCollectible_body_entered(body: Node) -> void:
	if !body.is_in_group("Player"):
		velocity = Vector3.ZERO
	if body.is_in_group("Islands"):
		target_island = body
		print("Water hits " + target_island.name)
		viable_root_target = true


func _on_WaterStopTimer_timeout() -> void:
	velocity = Vector3.ZERO
	collectable = true
