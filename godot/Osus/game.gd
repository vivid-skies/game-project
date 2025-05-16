extends Node

signal TimingPointChange



var config: Resource = preload("res://OsuLib/GameConfig.gd")
var beatmap_info: Dictionary = { 
	dir = "res://bin/processed/482090 9mm Parabellum Bullet - Inferno", 
	file_name = "9mm Parabellum Bullet - Inferno (Monstrata) [Agonizing Insane]" 
	}
var beatmap_file: String = beatmap_info.dir + "/" + beatmap_info.file_name + ".osu"


@onready var beatmap: Beatmap = OsuLib.Utils.Decode.beatmap_decode(beatmap_file, Beatmap.new())
@onready var time_delay: float = Time.get_ticks_usec()
@onready var time_start: float = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()

@onready var synchroniser: Node = $Synchroniser
@onready var audio_stream_player: AudioStreamPlayer = $Synchroniser/AudioStreamPlayer

const SECOND_MS: int = 60000
var last_half_beat: int = 0
var bpm: float
var bps: float # 60.0 / bpm
var hbps: float # bps * 0.5 # half beats per second

var timing_point_current: int

func _ready() -> void:
	print_debug(beatmap_file.get_file())
	setup_audio()
	play_audio()
	# timing_points()

# func timing_points() -> void:
# 	var timing_points: Array[Dictionary] = beatmap.get_timing_points()

# 	print_debug(timing_points.size())


func _process(_delta: float) -> void:
	# Not actually sure what this is all for cause this was from a demo
	var half_beat: int = int(get_elapsed_time() / hbps)
	if half_beat > last_half_beat: last_half_beat = half_beat


# I think I have this func to be a wrapper that sets up everything instead of calling everything from _ready()
func initialise_beatmap() -> void:
	pass


# Initialises the AudioStreamPlayer node with the music file, and sets the initial BPM of the track
func setup_audio() -> void:
	var file: String = beatmap.file_path.get_base_dir() + "/" + beatmap.general.audio_file_name
	var first_timing_point: Dictionary = beatmap.timing_points[0]

	audio_stream_player.stream  = AudioStreamMP3.load_from_file(file)
	# I HAVE NO IDEA WHAT IM DOING BUT YEAH IT WORKS
	bpm = config.set_bpm(first_timing_point.beat_length)
	bps = 60.0 / bpm
	hbps = bps * 0.5
	# SANITY CHECK
	print_debug(
		"BPM: ", bpm, "\n", 
		"BPS: ", bps, "\n",
		"HBPS: ", hbps, "\n",
	)


func play_audio() -> void:
	await(get_tree().create_timer(time_start).timeout)
	audio_stream_player.play()


func get_elapsed_time() -> float:
	return audio_stream_player.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()

func register_timing_point_event() -> void:
	var timing_point: Dictionary = beatmap.timing_points[0]
	var timing_point_next: Dictionary = beatmap.timing_points[1]
	
	self.timing_point_current = timing_point.time + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	self.bpm = config.get_bpm(timing_point.beat_length, timing_point.meter)

	# var timer: Timer = get_tree().create_timer()

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



# # This dictionary stores each time the bpm changes in the song. It's in dictionary format since I wrote it to support custom levels stored in .json files. It does not support gradual BPM changes.
# var bpm_changes:Array[Dictionary] = [ # Example value, sets the BPM to 120 at beat one and nothing else
# 	{
# 		"Crotchet":1.0, # The beat that the BPM changes
# 		"BPM":120,      # The BPM it changes to
# 	},
# ]

# func seconds_to_crotchet(seconds:float) -> float:
# 	var remaining_seconds : float = seconds # I don't think this is necessary in gdscript, but just to be safe
# 	var last_bpm : float = 100.0 # arbitrary value in case no bpm is set on beat 1
# 	var last_crotchet : float = 1.0
# 	var total_crotchets : float = 1.0
	
# 	for change in bpm_changes:
# 		var full: float  = remaining_seconds*last_bpm/60
# 		if full >= change["Crotchet"]:
# 			var diff: float = change["Crotchet"]-last_crotchet
# 			total_crotchets += diff
# 			remaining_seconds -= diff/last_bpm*60
# 			last_bpm = change["BPM"]
# 			last_crotchet = change["Crotchet"]
# 		else:
# 			break
# 	total_crotchets += remaining_seconds*last_bpm/60 + 1
	
# 	return total_crotchets


func _on_timer_timeout() -> void:
	pass # Replace with function body.
