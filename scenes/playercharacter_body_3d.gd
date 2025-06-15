extends CharacterBody3D

@export var speed := 5.0
@export var mouse_sensitivity := 0.010
@onready var head = $Head
@export var jump_velocity := 5.0
@export var inventory: Node
@onready var walk_sound = $WalkSound
var step_timer := 0.0

# ===== Obect Pick up ==================
var weapons_to_spawn
var weapons_to_drop
@onready var reach = $Head/PickupRay
@onready var hand = $Head/Hand
@onready var apple = preload("res://scenes/apple1.tscn")
@onready var sword = preload("res://scenes/sword2.tscn")
# =======================================

# ========== HealthBar ==================
@export var max_health: int = 100
var current_health: int = max_health

# Reference to the HealthBar (will be set in _ready)
var health_bar: TextureProgressBar



var rotation_x := 1.0
var rotation_y := 1.0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

var current_item = null

func _process(_delta):
	if reach.is_colliding():
		var collider = reach.get_collider()
		if collider.name == "apple" or collider.name == "sword": ############
			if Input.is_action_just_pressed("Pick Up"):
				if current_item == null:
					# Pickup item
					current_item = collider
					collider.queue_free()  # Remove from scene
					hand.add_child(current_item)
					current_item.global_position = hand.global_position
					current_item.global_rotation = hand.global_rotation
				else:
					# Drop current item
					hand.remove_child(current_item)
					get_parent().add_child(current_item)
					current_item.global_position = hand.global_position
					current_item.global_rotation = hand.global_rotation
					current_item = null

# ========================================================================

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
	
	if Input.is_action_just_pressed("Pick Up"):
		var ray = $Head/PickupRay
		print("GRABBING")
		if ray.is_colliding():
			var collider = ray.get_collider()
			print("COLLIDED")

			if hand.get_child_count() > 0:
				# Drop current item
				var item = hand.get_child(0)
				hand.remove_child(item)
				get_parent().add_child(item)
				item.global_transform = hand.global_transform
				if item.has_variable("dropped"):
					item.dropped = true

			if collider and collider is Node3D:
				print("NODE3D : "+collider.name)
				# Pick up item
				
				var new_item: Node3D
				match collider.name:
					"Apple":
						new_item = apple.instantiate()
					"Sword":
						new_item = sword.instantiate()
					_:
						print("Unrecognized item: ", collider.name)
						return
						
				
				ray.get_collider().queue_free()

				hand.add_child(new_item)
				new_item.transform = Transform3D.IDENTITY
				new_item.rotation = Vector3.ZERO
				new_item.position = Vector3.ZERO


	if Input.is_action_just_pressed("Drop An Item"):
		print("Dropped an item")

	if Input.is_action_just_pressed("Inventory"):
		print("Opened resource trunk")
		$Inventory.visible = !$Inventory.visible
		if $Inventory.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if Input.is_action_just_pressed("Attack"):
		print("Attack!")
		
	#print("On Floor:", is_on_floor(), "  Position Y:", position.y)
	

	# Footstep logic
	if is_on_floor() and direction != Vector3.ZERO:
		step_timer -= delta
		if step_timer <= 0:
			walk_sound.play()
			step_timer = 0.5  # Adjust for footstep interval
	else:
		step_timer = 0.0  # Reset timer when not moving
		walk_sound.stop()


func _toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
