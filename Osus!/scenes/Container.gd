extends Node3D

## Camera idle scale effect intensity.
const CAMERA_IDLE_SCALE = 0.005
var counter := 0.0

@onready var camera_base_rotation: Vector3 = $Camera3D.rotation

func _process(delta: float) -> void:
	# Animate the camera with an "idle" animation.
	counter += delta
	$Camera3D.rotation.x = camera_base_rotation.y + cos(counter) * CAMERA_IDLE_SCALE
	$Camera3D.rotation.y = camera_base_rotation.y + sin(counter) * CAMERA_IDLE_SCALE
	$Camera3D.rotation.z = camera_base_rotation.y + sin(counter) * CAMERA_IDLE_SCALE
