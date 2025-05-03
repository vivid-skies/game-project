extends Node3D


# var OsuLibNode: PackedScene = preload("res://OsuLib/OsuLib.tscn")
# var OsuLib: Node = null

var oszExample: String = ProjectSettings.globalize_path("res://OsuLib/imported/1381405 USAO - Cthugha.osz");


## Camera idle scale effect intensity.
const CAMERA_IDLE_SCALE = 0.005
var counter := 0.0

@onready var camera_base_rotation: Vector3 = $Camera3D.rotation

func _ready() -> void:
	if OsuLib:
		OsuLib.ImportOsz(oszExample)
	else:
		printerr("Failed to initialised OsuLib")

func _process(delta: float) -> void:
	# Animate the camera with an "idle" animation.
	counter += delta
	$Camera3D.rotation.x = camera_base_rotation.y + cos(counter) * CAMERA_IDLE_SCALE
	$Camera3D.rotation.y = camera_base_rotation.y + sin(counter) * CAMERA_IDLE_SCALE
	$Camera3D.rotation.z = camera_base_rotation.y + sin(counter) * CAMERA_IDLE_SCALE
