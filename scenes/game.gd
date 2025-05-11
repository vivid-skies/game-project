extends Node2D


# var OsuLibNode: PackedScene = preload("res://OsuLib/OsuLib.tscn")
# var Beatmap: RefCounted = preload("res://OsuLib/GDScript Conversion/Beatmap.gd")
# var OsuLib: Node = null
var oszExample: String = ProjectSettings.globalize_path("res://bin/imported/482090 9mm Parabellum Bullet - Inferno.osz")
var importedDirPath: String = ProjectSettings.globalize_path("res://bin/imported")
var beatmap_info: Dictionary = { dir = "res://bin/processed/482090 9mm Parabellum Bullet - Inferno", file_name = "9mm Parabellum Bullet - Inferno (Monstrata) [Agonizing Insane]" }
var beatmap_to_parse: String = beatmap_info["dir"] + "/" + beatmap_info["file_name"] + ".osu"



var beatmap : Beatmap
var beatmap_dir: String
var music_file: String
@onready var music_player: AudioStreamPlayer = %MusicPlayer


func _ready() -> void:
	beatmap = OsuLib.Utils.Decode.beatmap_decode(beatmap_to_parse)
	beatmap_dir = beatmap.file_path.get_base_dir()
	music_file = beatmap_dir + "/" + beatmap.general.audio_file_name
	print(music_file)

	var mp3_stream: AudioStreamMP3 = AudioStreamMP3.load_from_file(music_file)
	music_player.stream  = mp3_stream
	music_player.play()




func _process(_delta: float) -> void:
	pass

func debug() -> void:
	var hit_object_count: int = beatmap.hit_objects.size()

	var hit_circle_count: int = 0
	var slider_count: int = 0
	var spinner_count: int = 0

	for i in beatmap.hit_objects.size():
		if beatmap.hit_objects[i] is Beatmap.HitObject.HitCircleObject: hit_circle_count += 1
		elif beatmap.hit_objects[i] is Beatmap.HitObject.SpinnerObject: spinner_count += 1
		elif beatmap.hit_objects[i] is Beatmap.HitObject.SliderObject: slider_count += 1
	# print(beatmap.file_path)
	print("")
	print("[BEATMAP DATA]")
	print("File format version: ", beatmap.file_format_version)
	print("")
	print("Total Hit Objects: ", hit_object_count)
	print("\t Hit Circles: ", hit_circle_count)
	print("\t Spinners: ", spinner_count)
	print("\t Sliders: ", slider_count)
