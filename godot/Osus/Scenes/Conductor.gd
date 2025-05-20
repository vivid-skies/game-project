extends AudioStreamPlayer2D

signal b_beat(pos : int)
signal b_measure(position : int)
signal timing_point_change(index: int, AR: float, latency: float)
signal ConductorReady
signal HitObjectSpawn(index: int, AR: float, latency: float)

var difficulty: float 

# Tracking the beat and song position
const AUDIO_LATENCY: float = 15.0
const APPROACH_RATE: float = 1760.00
var song_pos : float = 0.0
var song_pos_ms: float = 0.0
var song_pos_ms_latency: float = 0.0

var song_pos_in_beats : int = 0
var sec_per_beat : float = 0
var bps: float
var last_reported_beat : int = 0
var beats_before_start : int = 0
var measure : int = 1

var hit_objects: Array
var hit_object_spawns: PackedInt32Array
var hit_object_counter: int = 0

var timing_points: Array[Dictionary]
var timing_point_offsets: PackedInt32Array
var timing_point_counter: int = 0
var last_beat_length: float = 0.0

# Determining how close to the beat an event is
var closest : int = 0
var time_off_beat : float = 0.0

var bpm: float = 0.0
var measures : int = 4
var curr_beat: float = 0.0
var curr_beat_without_latency: float = 0.0
var visual_offset_ms: int = 0


var _cached_latency: float = AudioServer.get_output_latency()
var _prev_time_seconds: float = 0.0


func _ready() -> void:
	# print_debug("Cached latency: ", _cached_latency)
	_report_ready()
	# print_debug(sec_per_beat)


func initialise(p_timing_points: Array[Dictionary], p_hit_objects: Array, audio_file: Resource, beat_offset: int = 4) -> void:
	# print_debug(timing_points.size())
	timing_points = p_timing_points.duplicate()
	hit_objects = p_hit_objects.duplicate()
	bpm = floor(calc_bpm(timing_points[0].beat_length, timing_points[0].meter))
	sec_per_beat = 60.0 / bpm
	bps = bpm / 60.0
	stream = audio_file
	for i in timing_points.size(): 
		timing_point_offsets.append(timing_points[i].time)
	for i in hit_objects.size(): 
		hit_object_spawns.append(hit_objects[i].time)


func _physics_process(_delta : float) -> void:
	if not playing: return
	var time_seconds: float = (
		get_playback_position()
		+ AudioServer.get_time_since_last_mix()
		- _cached_latency
		/ 1000.0
	)
	song_pos = time_seconds
	song_pos_ms = song_pos * 1000.0
	song_pos_in_beats = int(floor(song_pos / sec_per_beat)) + beats_before_start

	var i: int = timing_point_counter
	if i >= timing_point_offsets.size():
		print_debug("End of array, last timing point was: %s" % timing_point_offsets[i - 1])
		return

	if song_pos_ms >= (timing_point_offsets[i] - AUDIO_LATENCY) and song_pos_ms <= (timing_point_offsets[i] + AUDIO_LATENCY):
		song_pos_ms_latency = timing_point_offsets[i] - song_pos_ms
		# if i == 0: print_debug(timing_point_offsets.size())
		if timing_points[i].uninherited == 1: _timing_point_change(i)
		print_debug("\n","Data Pos: %s" % timing_point_offsets[i], " Actual Pos: %.2f" % song_pos_ms, " Latency %.2f " % song_pos_ms_latency,"\n", "BPM: ", bpm, " BPS: %.2f" % bps)
		timing_point_counter += 1
		# _report_metrics()
		# _report_time()
		# _report_beat()

	# Hit Object Spawning
	i = hit_object_counter
	if i >= hit_object_spawns.size():
		print_debug("End of array, last timing point was: %s" % hit_object_spawns[i - 1])
		return
		
	if hit_object_spawns[i] - APPROACH_RATE <= song_pos_ms :
		song_pos_ms_latency = hit_object_spawns[i] - APPROACH_RATE
		_report_hit_object_spawn(song_pos_ms_latency)

		hit_object_counter += 1
	
	_update_globals()
	# Fallback to guarentee timing point is changed
	# if song_pos_ms >= timing_points[i]:
	# 	print_debug("Fallback check triggered")
	# 	i += 1
	# 	pass


func _update_globals() -> void:
	Globals.song_pos_s = song_pos
	Globals.song_pos_ms = song_pos_ms
	Globals.song_pos_beats = song_pos_in_beats
	Globals.reported_latency = song_pos_ms_latency
	Globals.bpm = bpm
	Globals.bps = bps
	Globals.secs_per_beat = sec_per_beat
	# Globals.half_beat
	Globals.measure = measure
	Globals.timing_section_i = timing_point_counter
	Globals.hit_object_i = hit_object_counter
	Globals.last_reported_beat_length = last_beat_length

func _report_ready() -> void:
	emit_signal("ConductorReady")


func _timing_point_change(i: int) -> void:
	var beat_length: float = timing_points[i].beat_length
	var meter: int = timing_points[i].meter
	bpm = floor(calc_bpm(beat_length, meter))
	sec_per_beat = 60.0 / bpm
	bps = bpm / 60.0
	last_beat_length = beat_length

func _report_time() -> void:
	print_debug("%.0f" % song_pos_ms)

func _report_hit_object_spawn(latency: float) -> void:
	emit_signal("HitObjectSpawn", hit_object_counter, APPROACH_RATE, latency)
	

func _report_beat() -> void:
	if last_reported_beat < song_pos_in_beats:
		if measure > measures:
			measure = 1
		emit_signal("b_beat", song_pos_in_beats)
		emit_signal("b_measure", measure)
		last_reported_beat = song_pos_in_beats
		
		# print_debug(timing_points[i], ' Song: ' ,song_pos_ms)
		measure += 1

func _report_metrics() -> void:
	prints(
		"BPM:", bpm,
		"BPS:", bps, 
		"Recorded song pos:", song_pos_ms, 
		"Current time point:", timing_point_offsets[timing_point_counter]
	)

func play_with_beat_offset(num: int) -> void:
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()


func play_track() -> void:
	_prev_time_seconds = -_cached_latency - 0.001
	curr_beat = _prev_time_seconds / 60 * bpm
	play()
	pass


func closest_beat(nth : int) -> void:
	closest = int(round((song_pos / sec_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * sec_per_beat - song_pos)
	return Vector2(closest, time_off_beat)


func play_from_beat(beat: int, offset: int) -> void:
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	measure = beat % measures


func _on_StartTimer_timeout() -> void:
	song_pos_in_beats += 1
	if song_pos_in_beats < beats_before_start - 1: 
		$StartTimer.start()
	elif song_pos_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = ( 
			$StartTimer.wait_time - 
			(AudioServer.get_time_to_next_mix() + _cached_latency))
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()


func _get_song_pos() -> float:
	return (get_playback_position() + AudioServer.get_time_since_last_mix()) - _cached_latency


func calc_bpm(p_beat_length: float, p_meter: int) -> float:
	return (float(p_meter) / 4.0) / p_beat_length * 1000.0 * 60.0



func set_spinner_ammount(OD: float) -> float:
	assert(OD >= 0 and OD <= 10, "OD cannot be lower than 0 and be higher than 10! The OD was %s" % OD)
	var amount: float
	if OD < 5.0: 
		amount = 5.0 - 2.0 * (5.0 - OD) / 5.0
	elif OD == 5: 
		amount = 5.0
	elif OD > 5: 
		amount = 5.0 + 2.5 * (OD - 5.0) / 5.0
	return amount


func set_hit_window(OD: float) -> Dictionary:
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

func set_circle_size(CS: float) -> float:
	assert(CS >= 2 and CS <= 7, "CS cannot be lower than 2 and be higher than 7! The CS was %s" % CS)
	return 54.4 / 4.48 * CS

func set_approach_rate(AR: float) -> Dictionary:
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
