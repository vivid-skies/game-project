extends Node


# var OsuLibNode: PackedScene = preload("res://OsuLib/OsuLib.tscn")
# var Beatmap: RefCounted = preload("res://OsuLib/GDScript Conversion/Beatmap.gd")
# var OsuLib: Node = null
# var oszExample: String = ProjectSettings.globalize_path("res://bin/imported/482090 9mm Parabellum Bullet - Inferno.osz")
var beatmap_info: Dictionary = { 
	dir = "res://bin/processed/482090 9mm Parabellum Bullet - Inferno", 
	file_name = "9mm Parabellum Bullet - Inferno (Monstrata) [Agonizing Insane]" 
	}

var beatmap_to_parse: String = beatmap_info["dir"] + "/" + beatmap_info["file_name"] + ".osu"

var beatmap: Beatmap
var beatmap_dir: String

@onready var synchroniser: Node = $Synchroniser

func _ready() -> void:
	beatmap = OsuLib.Utils.Decode.beatmap_decode(beatmap_to_parse)
	beatmap_dir = beatmap.file_path.get_base_dir()

	synchroniser.load_file(beatmap)


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
	print(beatmap.file_path)
	print("")
	print("[BEATMAP DATA]")
	print("File format version: ", beatmap.file_format_version)
	print("")
	print("Total Hit Objects: ", hit_object_count)
	print("\t Hit Circles: ", hit_circle_count)
	print("\t Spinners: ", spinner_count)
	print("\t Sliders: ", slider_count)




# This dictionary stores each time the bpm changes in the song. It's in dictionary format since I wrote it to support custom levels stored in .json files. It does not support gradual BPM changes.
var bpm_changes:Array[Dictionary] = [ # Example value, sets the BPM to 120 at beat one and nothing else
	{
		"Crotchet":1.0, # The beat that the BPM changes
		"BPM":120,      # The BPM it changes to
	},
]

func seconds_to_crotchet(seconds:float) -> float:
	var remaining_seconds : float = seconds # I don't think this is necessary in gdscript, but just to be safe
	var last_bpm : float = 100.0 # arbitrary value in case no bpm is set on beat 1
	var last_crotchet : float = 1.0
	var total_crotchets : float = 1.0
	
	for change in bpm_changes:
		var full: float  = remaining_seconds*last_bpm/60
		if full >= change["Crotchet"]:
			var diff: float = change["Crotchet"]-last_crotchet
			total_crotchets += diff
			remaining_seconds -= diff/last_bpm*60
			last_bpm = change["BPM"]
			last_crotchet = change["Crotchet"]
		else:
			break
	total_crotchets += remaining_seconds*last_bpm/60 + 1
	
	return total_crotchets


func _on_timer_timeout() -> void:
	pass # Replace with function body.
