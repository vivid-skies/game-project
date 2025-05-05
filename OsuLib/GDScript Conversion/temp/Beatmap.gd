class_name Beatmap
extends RefCounted


# [General]
class General: 
	var audio_file_name: String = ""
	var audio_lead_in: int = 0
	var audio_hash: String = "" # DEPRECATED
	var preview_time: int = -1
	var countdown: Enums.Countdown = Enums.Countdown.NORMAL
	var sample_set: Enums.SampleSet = Enums.SampleSet.NONE
	var stack_leniency: float = 0.7
	var mode: Enums.Mode = Enums.Mode.NORMAL
	var letterbox_in_breaks: bool = false
	var story_fire_in_front: bool = true # DEPRECATED
	var use_skin_sprites: bool = false
	var always_show_playfield: bool = false # DEPRECATED
	var overlay_position: Enums.OverlayPosition = Enums.OverlayPosition.NO_CHANGE
	var skin_preference: String = ""
	var epilepsy_warning: bool = false
	var countdown_offset: int = 0
	var special_style: bool = false
	var widescreen_storyboard: bool = false
	var samples_match_playback_rate: bool = false


# [Editor]
class Editor: 
	var bookmarks: Array[int]
	var distance_spacing: float
	var beat_divisor: int
	var grid_size: int
	var timeline_zoom: float


# [Metadata]
class Metadata:
	var title: String
	var title_unicode: String
	var artist: String
	var artist_unicode: String
	var creator: String
	var version: String
	var source: String
	var tags: PackedStringArray
	var beatmap_id: int
	var beatmap_set_id: int


# [Difficulty]
class Difficulty:
	var hp_drain_rate: float
	var circle_size: float
	var overall_difficulty: float
	var approach_rate: float
	var slider_multiplier: float
	var slider_tick_rate: float


# [Events]
class Event:
	# Note: event_types will need to be reviewed 
	var event_type: Enums.Event
	var start_time: int = 0


class Media extends Event:
	var file_name: String
	var x_offset: int
	var y_offset: int


class Background extends Media:
	func _init() -> void:
		event_type = Enums.Event.BACKGROUND


class Video extends Media:
	func _init() -> void:
		event_type = Enums.Event.VIDEO


class Break extends Event:
	var end_time: int
	func _init() -> void:
		event_type = Enums.Event.BREAK


# NO SUPPORT FOR STORYBOARD ATM CAUSE I CBA
# class StoryBoard:
# 	pass


# [TimingPoints]
# Example entry: 690,307.692307692308,3,3,1,90,1,0
# 690 = time, 
# 307.692307692308 | -50 = beat_length,
# 3 = meter, 
# 3 = sample_set, 
# 1 = sample_index, 
# 90 = volume, 
# 1 = uninherited, 
# 0 = effects

class TimingPoint:
	var time: int
	var beat_length: float
	var meter: int
	var sample_set: Enums.SampleSet = Enums.SampleSet.NONE
	var sample_index: int
	var volume: int = 100
	var uninherited: bool
	var effect: Enums.Effect


class Colour:
	var combo_list: PackedInt32Array
	var slider_track_override: PackedInt32Array
	var slider_border: PackedInt32Array


# [HitObject]
class HitObject:
	var x: int
	var y: int
	var time: int
	var type: Enums.HitObject
	var hit_sound: Enums.HitSound
	var hit_sample: HitSample


class HitSample: 
	var normal_set: Enums.HitSample
	var addition_set: Enums.HitSample
	var index: int = 0
	var volume: int = 100
	var file_name: String


class HitCircle extends HitObject:
	pass


class Sliders extends HitObject:
	var curve_type: Enums.SliderCurve
	var curve_points: PackedInt64Array
	var length: float
	var edge_sounds: PackedInt64Array
	var edge_sets: EdgeSet


class EdgeSet:
	var normal_set: Enums.HitSample
	var addition_set: Enums.HitSample


class Spinner extends HitObject:
	var end_time: int
	func _init() -> void:
		x = 256
		y = 192


class Holds extends HitObject:
	pass
