extends CharacterBody3D

@export var speed := 5.0
@export var mouse_sensitivity := 0.010
@export var jump_velocity := 5.0
@export var inventory: Node
@onready var walk_sound = $WalkSound
var step_timer := 0.0



var rotation_x := 1.0
var rotation_y := 1.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89))
		rotation.y -= event.relative.x * mouse_sensitivity

		if $Head/Camera3D:
			$Head/Camera3D.rotation.x = rotation_x
			#$Camera3D.rotation.y = rotation_y
		# Handle pause toggle
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			_toggle_pause()

func _physics_process(delta):
	var direction = Vector3.ZERO
	var forward = -transform.basis.z
	var right = transform.basis.x

	if Input.is_action_pressed("Forward"):
		direction += forward
	if Input.is_action_pressed("Backward"):
		direction -= forward
	if Input.is_action_pressed("Right"):
		direction += right
	if Input.is_action_pressed("Left"):
		direction -= right

	

	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()
	
	# Handle interactions
	if Input.is_action_just_pressed("Pick Up"):
		var ray = $Camera3D/PickupRay
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider and collider.has_method("pick_up"):
				if not collider.is_connected("picked_up", inventory, "_on_item_picked"):
					collider.picked_up.connect(Callable(inventory, "_on_item_picked"))
				collider.pick_up()
				print("Picked up item")
			else:
				print("No pickable item in front.")

	if Input.is_action_just_pressed("Drop An Item"):
		print("Dropped an item")

	if Input.is_action_just_pressed("Resource Trunk"):
		print("Opened resource trunk")

	if Input.is_action_just_pressed("Attack"):
		print("Attack!")
		
	print("On Floor:", is_on_floor(), "  Position Y:", position.y)
	

	# Footstep logic
	if is_on_floor() and direction != Vector3.ZERO:
		step_timer -= delta
		if step_timer <= 0:
			walk_sound.play()
			step_timer = 0.5  # Adjust for footstep interval
	else:
		step_timer = 0.0  # Reset timer when not moving
		walk_sound.stop()

###Error is coming over heree!!!
func _toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
