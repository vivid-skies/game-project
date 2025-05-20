extends Node2D

@export var beatmap_file: String
@export var audio_file: Resource

var score: int = 0
var combo: int = 0

# Player performance stats
var max_combo: int = 0
var great: int = 0
var good: int = 0
var okay: int = 0
var missed: int = 0


# Audio statistics
# var bpm: int = 100
# var song_position: float = 0.0
var song_position_in_beats: int = 0
# var last_spawned_beat: int = 0
# var sec_per_beat: float = 60.0 / bpm


var spawn_1_beat: int = 0
var spawn_2_beat: int = 0
var spawn_3_beat: int = 1
var spawn_4_beat: int = 0
var lane: int = 0
var rand: int = 0

const PlAYFIELD: Vector2i = Vector2i(640, 480)

# var note = load("res://Scenes/ArrowNote.tscn")
var HitCircle: PackedScene = preload("res://Osus/Scenes/HitObjects/HitCircle/hit_circle.tscn")
var SliderObject: PackedScene = preload("res://Osus/Scenes/HitObjects/Slider/slider_object.tscn")

var instance: PackedScene

var beatmap: Beatmap
var hit_objects: Array
var timing_points: Array[Dictionary]

# Current timine point data
# var beat_legnth: float = 0.0
# var meter: int = 0
# var sample_set: int = 0
# var sample_index: int = 0
# var volume: int = 0
# var uninherited: int = 0
# var effects: int = 0
func _init() -> void:
	pass
func _ready() -> void:
	pass

func _on_conductor_ready() -> void:
	beatmap = OsuLib.Utils.Decode.beatmap_decode(beatmap_file, Beatmap.new())
	hit_objects = beatmap.get_hit_objects()
	timing_points = beatmap.get_timing_points()
	$Conductor.initialise(timing_points, hit_objects, audio_file, 4)
	$Conductor.play_track()
	# $Conductor.set_bpm(beat_length, meter)
	# $Conductor.timing_points = times
	# $Conductor.set("stream", audio_file)
	# $Conductor.play_with_beat_offset(0)

func _spawn_hit_objects(index: int, AR: float, latency: float) -> void:
	var hit_object: Variant = hit_objects[index]

	match hit_object.type as OsuLib.Enums.HitObject:
		OsuLib.Enums.HitObject.NONE:
			push_error("HitObject type is NONE")
		OsuLib.Enums.HitObject.CIRCLE:
			var hit_circle: Node = HitCircle.instantiate()
			$Playfield.add_child(hit_circle)
			hit_circle.initialise(AR / 1000.0, hit_object.coord)
		OsuLib.Enums.HitObject.SLIDER:
			# Note need to link the current hitobject to the SliderObject instance
			var slider: Node = load("res://Osus/Scenes/HitObjects/Slider/slider_object.tscn").instantiate()

			var beat_length: float 
			var slider_multiplier: float = beatmap.difficulty.slider_multiplier
			var slider_velocity: float
			var coords: PackedVector2Array
			var loops: int = hit_object.slides

			coords.append(hit_object.coord)

			for point: Vector2 in hit_object.curve_points:
				coords.append(point)

			if timing_points[Globals.timing_section_i].uninherited == 1:
				beat_length = timing_points[Globals.timing_section_i].beat_length
				slider_velocity = 1.0 # Set to 1.0 if beat_length isn't a slider velocity
			else:
				# Set beat length to last reported beat length if timing point is inherited
				beat_length = Globals.last_reported_beat_length
				slider_velocity = calculate_slider_velocity(timing_points[Globals.timing_section_i].beat_length) 

			var duration: float = hit_object.length / (slider_multiplier * 100.0 * slider_velocity) * beat_length
			duration = duration + Globals.reported_latency / 1000.0

			$Playfield.add_child(slider)

			slider.initialise(duration, Globals.bps, coords, loops)
			pass
		OsuLib.Enums.HitObject.NEW_COMBO:
			pass
		OsuLib.Enums.HitObject.SPINNER:
			pass
		OsuLib.Enums.HitObject.ONE_SKIP:
			pass
		OsuLib.Enums.HitObject.TWO_SKIP:
			pass
		OsuLib.Enums.HitObject.THREE_SKIP:
			pass

	pass

func calculate_slider_velocity(SV: float) -> float:
	assert(SV < 0, "Slider Multiplier was %s" %SV)

	return abs(100.0 / SV)

func _on_Conductor_measure(position : int) -> void:
	# print_debug(position)
	pass
	# if position == 1:
	# 	_spawn_notes(spawn_1_beat)
	# elif position == 2:
	# 	_spawn_notes(spawn_2_beat)
	# elif position == 3:
	# 	_spawn_notes(spawn_3_beat)
	# elif position == 4:
	# 	_spawn_notes(spawn_4_beat)

func _on_Conductor_beat(position : int) -> void:
	song_position_in_beats = position
	# print_debug(position)
	# if song_position_in_beats > 16:
	# 	spawn_1_beat = 1
	# 	spawn_2_beat = 1
	# 	spawn_3_beat = 1
	# 	spawn_4_beat = 1
	# if song_position_in_beats > 28:
	# 	spawn_1_beat = 2
	# 	spawn_2_beat = 0
	# 	spawn_3_beat = 1
	# 	spawn_4_beat = 0
	# if song_position_in_beats > 40:
	# 	spawn_1_beat = 0
	# 	spawn_2_beat = 2
	# 	spawn_3_beat = 1
	# 	spawn_4_beat = 2
	# if song_position_in_beats > 50:
	# 	spawn_1_beat = 2
	# 	spawn_2_beat = 2
	# 	spawn_3_beat = 1
	# 	spawn_4_beat = 1
	# if song_position_in_beats > 60:
	# 	# Global.set_score(score)
	# 	# Global.combo = max_combo
	# 	# Global.great = great
	# 	# Global.good = good
	# 	# Global.okay = okay
	# 	# Global.missed = missed
	# 	if get_tree().change_scene_to_file("res://Scenes/Intro.tscn") != OK:
	# 		print ("Error changing scene to Intro")

# func _spawn_notes(to_spawn: int) -> void:
# 	if to_spawn > 0:
# 		lane = randi() % 3
# 		# instance = note.instantiate()
# 		instance.initialize(lane)
# 		add_child(instance)
# 	if to_spawn > 1:
# 		while rand == lane:
# 			rand = randi() % 3
# 		lane = rand
# 		# instance = note.instantiate()
# 		instance.initialize(lane)
# 		add_child(instance)
		


func increment_score(by : int) -> void:
	if by > 0:
		combo += 1
	else:
		combo = 0
	
	if by == 3:
		great += 1
	elif by == 2:
		good += 1
	elif by == 1:
		okay += 1
	else:
		missed += 1
	
	
	score += by * combo
	$Label.text = str(score)
	if combo > 0:
		$Combo.text = str(combo) + " combo!"
		if combo > max_combo:
			max_combo = combo
	else:
		$Combo.text = ""


func reset_combo() -> void:
	combo = 0
	$Combo.text = ""

func _on_conductor_finished() -> void:
	if get_tree().change_scene_to_file("res://Scenes/Intro.tscn") != OK:
		print ("Error changing scene to Intro")

func _on_timing_point_change(index: int) -> void:
	
	pass


