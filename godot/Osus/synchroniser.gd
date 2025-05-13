extends Node

const second_ms: int = 60000



var last_half_beat : int = 0

var beatmap: Beatmap
var bpm : float
var bps : float # 60.0 / bpm
var hbps : float # bps * 0.5 # half beats per second

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_ready() -> void:
	pass

func load_file(p_beatmap: Beatmap) -> void:
	beatmap = p_beatmap
	
	var file: String = beatmap.file_path.get_base_dir() + "/" + beatmap.general.audio_file_name
	audio_player.stream  = AudioStreamMP3.load_from_file(file)

	# I HAVE NO IDEA WHAT IM DOING BUT YEAH IT WORKS
	bpm = beatmap.timing_points[0].bpm
	bps = 60.0 / bpm
	hbps = bps * 0.5

	# SANITY CHECK
	# print_debug(
	# 	"BPM: ", bpm, "\n", 
	# 	"BPS: ", bps, "\n",
	# 	"HBPS: ", hbps, "\n",
	# 	)


	play_audio()


func play_audio() -> void:
	var time_delay : float = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	
	get_tree().create_timer(time_delay)
	audio_player.play()

func _process(_delta:float) -> void:
	var time: float = (
		audio_player.get_playback_position()
		+ AudioServer.get_time_since_last_mix()
		- AudioServer.get_output_latency()
	)
	
	var half_beat : int = int(time / hbps)
	
	if half_beat > last_half_beat:
		last_half_beat = half_beat
		# Events.emit_signal("beat_incremented", {"half_beat" : half_beat, "bps": bps})


# func get_bpm(timing_point: Beatmap.TimingPoint) -> void:
	# var uninherited : int = timing_point.uninherited
	# var beat_length : float = timing_point.beat_length 
	# var time : int = timing_point.time
	# var effects : int = timing_point.effects
	# var kiai : int = 1000 if effects == 1 else -1
	
	# if uninherited: 
	# 	bpm = uninherited / beat_length * kiai * 60.00
	# else:
	# 	bpm =  uninherited / beat_length * kiai * 60.00

	# bps = 60.0 / bpm
	# hbps = bps * 0.5

	# print("BPM: ", bpm)
	# print("BPS: ", bps)
	# print("HBPS: ", hbps)




func debug() -> void:
	var timing_point: Beatmap.TimingPoint = beatmap.timing_points[0]

	var _flags : PropertyUsageFlags = PROPERTY_USAGE_SCRIPT_VARIABLE
	var test : Variant = timing_point.get_script().get_property_list()
	print(test)
	for prop in timing_point.get_property_list():
		if prop.type == 3:
			print(prop)
		pass
		# if(prop.usage and flags > 0):
		# 	print(prop.name, ' = ', timing_point.get(prop.name))
