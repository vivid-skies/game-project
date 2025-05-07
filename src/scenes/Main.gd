extends Node3D


var OsuLibNode: PackedScene = preload("res://OsuLib/OsuLib.tscn")
# var Beatmap: RefCounted = preload("res://OsuLib/GDScript Conversion/Beatmap.gd")
# var OsuLib: Node = null

var oszExample: String = ProjectSettings.globalize_path("res://bin/imported/482090 9mm Parabellum Bullet - Inferno.osz")
var importedDirPath: String = ProjectSettings.globalize_path("res://bin/imported")

var beatmap_info: Dictionary = {
	dir = "res://bin/processed/482090 9mm Parabellum Bullet - Inferno",
	file_name = "9mm Parabellum Bullet - Inferno (Monstrata) [Agonizing Insane]"
}

var beatmap_to_parse: String = beatmap_info["dir"] + "/" + beatmap_info["file_name"] + ".osu"

## Camera idle scale effect intensity.
const CAMERA_IDLE_SCALE = 0.005
var counter := 0.0

@onready var camera_base_rotation: Vector3 = $Camera3D.rotation

func _ready() -> void:
	var beatmap: Beatmap = Beatmap.new()
	beatmap.decode(beatmap_to_parse)
	beatmap.test()




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
