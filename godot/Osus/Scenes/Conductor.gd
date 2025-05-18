extends AudioStreamPlayer2D


signal b_beat(position : int)
signal b_measure(position : int)
signal timing_point_change(index: int)


# Tracking the beat and song position
var song_position : float = 0.0
var song_position_ms: float = 0.0
var song_position_in_beats : int = 0
var sec_per_beat : float = 60.0 / bpm
var last_reported_beat : int = 0
var beats_before_start : int = 0
var measure : int = 1

@onready var timing_points: PackedInt32Array
var i: int = 0

# Determining how close to the beat an event is
var closest : int = 0
var time_off_beat : float = 0.0

var bpm : int = 145
var measures : int = 4
var curr_beat: float = 0
var curr_beat_without_latency: float = 0
var visual_offset_ms: int = 0


var _cached_latency: float = AudioServer.get_output_latency()
var _prev_time_seconds: float = 0

func _ready() -> void:
	sec_per_beat = 60.0 / bpm
	# print_debug(sec_per_beat)


func _process(_delta : float) -> void:
	if not playing:
		return
	
	var time_seconds: float = (
		(get_playback_position()
		+ AudioServer.get_time_since_last_mix())
		- _cached_latency
		/ 1000.0)
	
	song_position = time_seconds
	song_position_ms = song_position * 1000.0
	song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start

	if song_position_ms >= timing_points[i] - 5.0 and song_position_ms <= timing_points[i] + 5.0:
		if i == 0:
			print_debug(timing_points.size())

		print_debug("timing point hit: ", timing_points[i])
		# prints(song_position_ms, timing_points[i])
		if i + 1 > timing_points.size() - 1:
			print_debug("at the end")
			set_physics_process(false)

		i += 1
	# _report_time()
	# _report_beat()




func set_timing_point() -> void:
	if song_position == timing_points[0]:
		emit_signal("timing_point_change")
		timing_points.remove_at(0)

func _report_time() -> void:
	print_debug("%.0f" % song_position_ms)

func _report_beat() -> void:
	if last_reported_beat < song_position_in_beats:
		if measure > measures:
			measure = 1
		emit_signal("b_beat", song_position_in_beats)
		emit_signal("b_measure", measure)
		last_reported_beat = song_position_in_beats
		
		# print_debug(timing_points[i], ' Song: ' ,song_position_ms)
		measure += 1


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
	closest = int(round((song_position / sec_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)


func play_from_beat(beat: int, offset: int) -> void:
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	measure = beat % measures


func _on_StartTimer_timeout() -> void:
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = (
			$StartTimer.wait_time - 
			(AudioServer.get_time_to_next_mix() + _cached_latency)
		)
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()

	_report_beat()


func _get_song_position() -> float:
	return (get_playback_position() + AudioServer.get_time_since_last_mix()) - _cached_latency


static func set_bpm(beat_length: float, meter: int) -> float: 
	return (meter / 4) / beat_length * 1000.0 * 60.0

func _is_valid_update(time_seconds: float) -> bool:
	return(
		time_seconds < 1000 and (
			# Time moved forward
			time_seconds > _prev_time_seconds or 
			# Loop happened
			time_seconds - _prev_time_seconds < -5))
