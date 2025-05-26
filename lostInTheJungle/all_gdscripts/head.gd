extends Node3D  # This is the "Head" node (pivot for pitch)

@export var player: CharacterBody3D
@export var mouse_sensitivity := 0.002

var rotation_x := 0.0  # pitch (up/down)
var rotation_y := 0.0  # yaw (left/right)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if player:
		rotation_y = player.rotation.y

func _unhandled_input(event):
	if event is InputEventMouseMotion and player:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity

		# Clamp pitch to avoid flipping
		rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89))

		# Rotate the player (yaw)
		player.rotation.y = rotation_y

		# Rotate the head (pitch)
		rotation.x = rotation_x

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
