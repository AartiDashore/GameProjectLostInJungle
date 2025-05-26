extends RigidBody3D

signal picked_up(resource_id: String)

@export var resource_id: String = "apple"

func _ready():
	# Optional: connect signal in code if needed
	# picked_up.connect(Callable(get_tree().get_root(), "_on_apple_picked"))
	pass

func pick_up():
	print("Apple picked!")
	emit_signal("picked_up", resource_id)
	queue_free()
