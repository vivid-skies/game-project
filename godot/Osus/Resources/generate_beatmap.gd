extends Node


var beatmap: Beatmap
var file_info: Dictionary
var general: Dictionary
var metadata: Dictionary

var beatmap_scene: Node
var timing_section: Node

func _init(file: String) -> void:
	beatmap_scene = Node.new()
	timing_section = Node.new()

	beatmap = OsuLib.Utils.Decode.beatmap_decode(file, Beatmap.new())

	file_info = beatmap.get_file_info()
	general = beatmap.get_general()
	metadata = beatmap.get_metadata()
	
	

func create_beatmap() -> void:
	beatmap_scene.name = beatmap.file_name
	# osu file format v14
	# [General]
	# [Editor]
	# [Metadata]
	# [Difficulty]
	# [Events]
	# //Background and Video events
	# //Break Periods
	# [TimingPoints]
	# [Colours]
	# [HitObjects]
	# timing_section.owner = beatmap

	save_assets()
	save_scene()
	
	queue_free()

func save_scene() -> void:
	var scene: PackedScene = PackedScene.new()
	var res: Error = scene.pack(beatmap_scene)
	
	print_debug("Saving Beatmap Scene....")

	if res == OK:
		var error: Error = ResourceSaver.save(scene, "res://Osus/Beatmaps/%s/%s.tscn" % file_info.file_name.get_slice(".osu", 0))
		if error != OK: push_error("An error occured while saving the scene to disk.")

func save_assets() -> void:
	var fromDir: String = file_info.file_path.get_base_dir()
	var toDir: String = "res://Osus/Beatmaps/%s" 

	var audio_file: Resource = load(fromDir + "/" + general.audio_file_name)
	var beatmap_file: Resource = load(fromDir + "/" + file_info.file_name)
	
	ResourceSaver.save(audio_file, toDir + "/" % general.audio_file_name)
	ResourceSaver.save(beatmap_file, toDir  + "/" % file_info.file_name)
