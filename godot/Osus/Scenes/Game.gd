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


# var note = load("res://Scenes/ArrowNote.tscn")

var instance: Variant

@onready var beatmap: Beatmap = OsuLib.Utils.Decode.beatmap_decode(beatmap_file, Beatmap.new())

# Current timine point data
# var beat_legnth: float = 0.0
# var meter: int = 0
# var sample_set: int = 0
# var sample_index: int = 0
# var volume: int = 0
# var uninherited: int = 0
# var effects: int = 0

func _ready() -> void:
	var times: PackedInt32Array
	for timing_point in beatmap.timing_points:
		var time: int = timing_point.time
		times.append(timing_point.time)

	$Conductor.timing_points = times
	$Conductor.set("stream", audio_file)
	$Conductor.play_with_beat_offset(4)


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

func _spawn_notes(to_spawn : int) -> void:
	if to_spawn > 0:
		lane = randi() % 3
		# instance = note.instantiate()
		instance.initialize(lane)
		add_child(instance)
	if to_spawn > 1:
		while rand == lane:
			rand = randi() % 3
		lane = rand
		# instance = note.instantiate()
		instance.initialize(lane)
		add_child(instance)
		


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
