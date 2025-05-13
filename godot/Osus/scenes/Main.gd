extends Node3D

var beatmap_gen_script: Resource = load("res://Osus/Editor/beatmap_generator.gd")
var beatmap_gen: Variant
## Camera idle scale effect intensity.
const CAMERA_IDLE_SCALE : float = 0.005
var counter : float = 0.0

@onready var camera_base_rotation: Vector3 = $Camera3D.rotation


func _ready() -> void:
	print("main")
	beatmap_gen = beatmap_gen_script.new()
	# beatmap_gen.create_area()

func _process(delta: float) -> void:
	# Animate the camera with an "idle" animation.
	counter += delta
	$Camera3D.rotation.x = camera_base_rotation.y + cos(counter) * CAMERA_IDLE_SCALE
	$Camera3D.rotation.y = camera_base_rotation.y + sin(counter) * CAMERA_IDLE_SCALE
	$Camera3D.rotation.z = camera_base_rotation.y + sin(counter) * CAMERA_IDLE_SCALE

func _process_imported_osu_files(p_dir_path: String) -> void:
	print(p_dir_path)
	var dir: DirAccess = DirAccess.open(p_dir_path)
	if dir:
		dir.list_dir_begin()
		var file: String = dir.get_next()
		while file != "":
			if dir.current_is_dir(): 
				print("file is directory... skipping")
			else:
				var file_path: String = p_dir_path + "/" + file
				OsuLib.ImportOsz(file_path)
	else: print("Could not open: ", p_dir_path)
