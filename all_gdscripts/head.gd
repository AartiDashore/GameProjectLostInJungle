extends Node3D  # This is the "Head" node (pivot for pitch)

@export var player: CharacterBody3D

var rotation_x := 0.0  # pitch (up/down)
var rotation_y := 0.0  # yaw (left/right)

@export var speed := 5.0
@export var mouse_sensitivity := 0.010



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	if player:  # Prevents Nil errors
		var target_position = player.global_position + Vector3(0,2,0)
		var next_position = target_position #.lerp(target_position, delta * 100.0)
		var _offset = next_position - global_position
		transform = Transform3D.IDENTITY.rotated(Vector3(1,0,0),rotation_x).translated(Vector3(0,10,0));

	else:
		print("Warning: Player node not assigned!")
		

func _unhandled_input(event):
		#=================================================================
	if event is InputEventMouseMotion:
		rotation_x -= event.relative.y * mouse_sensitivity
		
		rotation_y -= event.relative.x * mouse_sensitivity

		if player:
			player.rotation.y = rotation_y


	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			_toggle_pause()

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
