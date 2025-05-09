extends Camera3D

@export var player: Node3D  # Drag your player node here in the Inspector

#func _process(delta):
	#var target_position = player.global_transform.origin + Vector3(0, 2, -3) # Offset camera
	#wdwdglobal_transform.origin = global_transform.origin.lerp(target_position, delta * 5.0) # Smooth follow
	#global_transform.basis = global_transform.basis.slerp(player.global_transform.basis, delta * 5.0) # Smooth rotation
func _process(delta):
	if player:  # ✅ Prevents Nil errors
		var target_position = player.global_transform.origin + Vector3(0, 2, -3)
		global_transform.origin = global_transform.origin.lerp(target_position, delta * 5.0)
	else:
		print("Warning: Player node not assigned!")
