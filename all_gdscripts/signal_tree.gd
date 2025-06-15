extends Node3D

@export var tilt_strength: float = 10.0 # degrees of sway
@export var sway_speed: float = 2.0     # how fast the tree sways
@export var tilt_axis: Vector3 = Vector3(1, 0, 0)  # axis to sway around

var is_player_near = false
var original_rotation: Basis
var sway_timer: float = 0.0

func _ready():
	original_rotation = transform.basis

#func _process(delta):
#	if is_player_near:
#		sway_timer += delta * sway_speed
#		var angle = deg_to_rad(sin(sway_timer) * tilt_strength)
#		var sway = Basis(tilt_axis.normalized(), angle)
#		transform.basis = original_rotation * sway
#	else:
#		sway_timer = 0.0
#		transform.basis = original_rotation

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		is_player_near = true

func _on_area_3d_body_exited(body):
	if body.name == "Player":
		is_player_near = false
