extends RigidBody3D

signal picked_up(resource_id: String)

@export var resource_id: String = "apple"

var dropped = false

func _ready():
	# Optional: connect signal in code if needed
	# picked_up.connect(Callable(get_tree().get_root(), "_on_apple_picked"))
	pass

func _process(delta):
	if dropped == true:
		apply_impulse(transform.basis.z, -transform.basis.z * 10)
		dropped = false


func pick_up():
	print("Apple picked!")
	emit_signal("picked_up", resource_id)
	queue_free()
