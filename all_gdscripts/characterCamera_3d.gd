extends Camera3D

@export var player: Node3D
@export var mouse_sensitivity := 0.00025
var rotation_x := 0.0  # Vertical look (X axis)
var rotation_y := 0.0  # Horizontal look (yaw)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#func _process(delta):
	#var target_position = player.global_transform.origin + Vector3(0, 2, -3) # Offset camera
	#wdwdglobal_transform.origin = global_transform.origin.lerp(target_position, delta * 5.0) # Smooth follow
	#global_transform.basis = global_transform.basis.slerp(player.global_transform.basis, delta * 5.0) # Smooth rotation
func _process(delta):
	if player:  # Prevents Nil errors
		var target_position = player.global_position + Vector3(0,2,0)
		var next_position = global_position.lerp(target_position, delta * 100.0)
		var offset = next_position - global_position
		transform = transform.translated(offset)
		
		#var mat := $Camera3D.material_override as ShaderMaterial 	#For Fog Shader
		#if mat:
			#mat.set_shader_parameter("camera_position", get_viewport().get_camera_3d().global_transform.origin)

	else:
		print("Warning: Player node not assigned!")
		
func _unhandled_input(event):
	if event is InputEventMouseMotion and player:
		pass
		# Horizontal rotation (player turns)
		#rotation_y -= event.relative.x * mouse_sensitivity
		#player.rotation.y = rotation_y
		
		#rotation_x -= event.relative.y * mouse_sensitivity
		#rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89))
		#rotation.x = rotation_x # Vertical rotation (up/down) applied to the camera
