extends Node

signal TimingPointChange

var game: Dictionary = {
	difficulty = {
		spinner_min = 0.0,
		circle_size = 0.0,
		approach_rate = 0.0,
		hit_window = { 
			great = 0.0, 
			ok = 0.0, 
			meh = 0.0 
		},
	},
	timing_section = {
		bpm = 0.0,
		beat_length = 0.0,
		meter = 0,
		sample_set = 0,
		sample_index = 0,
		volume = 0,
		uninherited = 0,
		effects = 0,
	},

}

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

var last_half_beat: int = 0
# var bpm: float
# var bps: float # 60.0 / bpm
# var hbps: float # bps * 0.5 # half beats per second

var timing_point_current: int = 0
var timing_point_queue: PackedFloat32Array

@onready var game_clock: bool = true

func _ready() -> void:
	# print_debug(beatmap_file.get_file())
	set_process(false)
	initialise_beatmap()
	print_debug(game)
	# setup_audio()
	# play_audio()
	# _print_game_clock()
	# timing_points()

# func timing_points() -> void:
# 	var timing_points: Array[Dictionary] = beatmap.get_timing_points()

# 	print_debug(timing_points.size())


func _process(delta: float) -> void:
	# Not actually sure what this is all for cause this was from a demo
	# var half_beat: int = int(get_elapsed_time() / hbps)
	# if half_beat > last_half_beat: last_half_beat = half_beat

	
	var elapsed_time: float = get_elapsed_time() - delta
	print_debug(roundi(elapsed_time))


# I think I have this func to be a wrapper that sets up everything instead of calling everything from _ready()
func initialise_beatmap() -> void:
	for timing_point in beatmap.timing_points:
		var time: int = timing_point.time
		timing_point_queue.append(time)
	
	set_current_timing_section_config(beatmap.timing_points[timing_point_current])
	
	initialise_difficulty_config()

func initialise_difficulty_config() -> void:
	var difficulty: Dictionary = beatmap.get_difficulty()
	var spinner_amount: float = set_spinner_ammount(difficulty.overall_difficulty)
	var hit_window: Dictionary = set_hit_window(difficulty.overall_difficulty)
	game.difficulty  = difficulty
	game.difficulty.hit_window = hit_window
	game.difficulty.spinner_amount = spinner_amount

func set_current_timing_section_config(timing_section: Dictionary) -> void:
	var bpm: int = roundi(get_bpm(timing_section.beat_length, timing_section.meter))
	assert(bpm > 0, "BPM is 0 for some reason")
	print_debug(bpm)

	game.timing_section = timing_section
	game.timing_section.bpm = bpm

func _print_game_clock() -> void:
	while game_clock:
		await get_tree().create_timer(1).timeout
		var elapsed_time: float = get_elapsed_time()
		print_debug(roundi(elapsed_time))

# Initialises the AudioStreamPlayer node with the music file, and sets the initial BPM of the track
func setup_audio() -> void:
	var file: String = beatmap.file_path.get_base_dir() + "/" + beatmap.general.audio_file_name
	# var first_timing_point: Dictionary = beatmap.timing_points[0]

	audio_stream_player.stream  = AudioStreamMP3.load_from_file(file)
	# I HAVE NO IDEA WHAT IM DOING BUT YEAH IT WORKS
	# bpm = get_bpm(first_timing_point.beat_length, first_timing_point.meter)
	# bps = 60.0 / bpm
	# hbps = bps * 0.5
	# # SANITY CHECK
	# print_debug(
	# 	"BPM: ", bpm, "\n", 
	# 	"BPS: ", bps, "\n",
	# 	"HBPS: ", hbps, "\n",
	# )


func play_audio() -> void:
	# await(get_tree().create_timer(time_start).timeout)
	audio_stream_player.play()
	print_debug("Audio started @ ", get_elapsed_time())


func get_elapsed_time() -> float:
	var elapsed_time: float = seconds_to_milliseconds(audio_stream_player.get_playback_position())
	var audio_delay: float = AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	return(elapsed_time + audio_delay)

func seconds_to_milliseconds(s: float) -> float: 
	return s * 1000.0

func millisconds_to_seconds(s: float) -> float: 
	return s / 1000.0

func microseconds_to_milliseconds(s: float) -> float: 
	return s / 100.0

# grab the current time and next time of timing points
# next_timing - current _timing to get the timer duration
# Register timing point set to the duration
func queue_timing_point_change(delta: float) -> void:
	if (get_elapsed_time() - delta) == timing_point_queue[0]: emit_signal("TimingPointChange")

func _on_timing_point_change() -> void:
	var timing_point: Dictionary = beatmap.timing_points[timing_point_current]
	timing_point_current += 1

	# for time in timer_queue:
	# 	var timer: SceneTreeTimer = get_tree().create_timer()
	# var current_time: float = beatmap.timing_points[0].time
	# var next_time float = beatmap.timing_points[1].time
	
	# self.timing_point_current = timing_point.time + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	# self.bpm = config_script.get_bpm(timing_point.beat_length, timing_point.meter)

	# var timer: Timer = get_tree().create_timer()

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

static func set_spinner_ammount(OD: float) -> float:
	assert(OD >= 0 and OD <= 10, "OD cannot be lower than 0 and be higher than 10! The OD was %s" % OD)
	
	var amount: float

	if OD < 5.0: 
		amount = 5.0 - 2.0 * (5.0 - OD) / 5.0
	elif OD == 5: 
		amount = 5.0
	elif OD > 5: 
		amount = 5.0 + 2.5 * (OD - 5.0) / 5.0

	return amount

static func set_hit_window(OD: float) -> Dictionary:
	assert(OD >= 0 and OD <= 10, "OD cannot be lower than 0 and be higher than 10! The OD was %s" % OD)

	var perfect: float = 80.0 - (6.0 * OD)
	var great: float = 140.0 - (8.0 * OD)
	var ok: float = 200.0 - (10.0 * OD)

	# this is just for debugging
	if OD == 3:
		var assDict: Dictionary = { perfect = 62.00, great = 116.00, ok = 170.00 }
		assert(perfect == assDict.perfect + "Perfect calcs do not match up!" + "Perfect: " + perfect + "Assert: " + assDict.perfect)
		assert(great == assDict.great + "Great calcs do not match up!" + "Great: " + great + "Assert: " + assDict.great)
		assert(perfect == assDict.ok + "Ok calcs do not match up!" + "Ok: " + ok + "Assert: " + assDict.ok)

	return {
		perfect = perfect,
		great = great,
		ok = ok,
	}

static func set_circle_size(CS: float) -> float:
	assert(CS >= 2 and CS <= 7, "CS cannot be lower than 2 and be higher than 7! The CS was %s" % CS)

	return 54.4 / 4.48 * CS

static func set_approach_rate(AR: float) -> Dictionary:
	assert(AR > 0 and AR <= 10, "AR cannot be lower than 0 and be higher than 10! The AR was %s" % AR)
	# Approach rate is calculate by X - preempt
	# The hit object starts fading in at X - preempt with:
		# AR < 5: preempt = 1200ms + 600ms * (5 - AR) / 5
		# AR = 5: preempt = 1200ms
		# AR > 5: preempt = 1200ms - 750ms * (AR - 5) / 5

	# The amount of time it takes for the hit object to completely fade in is also reliant on the approach rate:
		# AR < 5: fade_in = 800ms + 400ms * (5 - AR) / 5
		# AR = 5: fade_in = 800ms
		# AR > 5: fade_in = 800ms - 500ms * (AR - 5) / 5

	var preempt: float
	var fade_in: float
	var assVal: float

	if AR < 5.0: 
		preempt = 1200.0 + 600.0 * (5.0 - AR) / 5.0
		fade_in = 800 + 400 * (5.0 - AR) / 5.0

		# Assert if AR is 2
		assVal = 1560.0
		assert(preempt == assVal, "Expected prempt to be  1560.0, but it was %s" % preempt)

	elif AR == 5.0: 
		preempt = 1200.0
		fade_in = 800.0

		# Assert if AR is 5
		assVal = 1200.0
		assert(preempt == assVal, "Expected prempt to be  1200.0, but it was %s" % preempt)
	elif AR > 5.0: 
		preempt = 1200.0 - 750.0 * (AR - 5.0) / 5.0
		fade_in = 800.0 - 500.0 * (AR - 5.0) / 5.0

		# Assert if AR is 7
		assVal = 900.0
		assert(preempt == assVal, "Expected prempt to be  900.0, but it was %s" % preempt)
	
	return {
		preempt = preempt,
		fade_in = fade_in,
	}

static func get_bpm(beat_length: float, time_signature: float) -> float:
	return (time_signature / 4.0) / beat_length * 1000.0 * 60.0
