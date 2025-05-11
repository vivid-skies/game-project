class_name Beatmap
extends Object

var file_format_version: int
var file_path: String
# Sections
var general: General
var editor: Editor
var metadata: Metadata
var difficulty: Difficulty

# Events
var background_events: Array[Background]
var video_events: Array[Video]
var break_events: Array[Break]

var timing_points: Array[TimingPoint]

# Colours
var combo_colours: Array[PackedInt32Array]
var slider_track_override: PackedInt32Array
var slider_border: PackedInt32Array

var hit_objects: Array

func _init() -> void:
	general = General.new()
	editor = Editor.new()
	metadata = Metadata.new()
	difficulty = Difficulty.new()

class General:
	var audio_file_name: String = ""
	var audio_lead_in: int = 0
	var audio_hash: String = "" # DEPRECATED
	var preview_time: int = -1
	var countdown: int = 0
	var sample_set: int = 0
	var stack_leniency: float = 0.7
	var mode: int = 0
	var letterbox_in_breaks: bool = false
	var story_fire_in_front: bool = true # DEPRECATED
	var use_skin_sprites: bool = false
	var always_show_playfield: bool = false # DEPRECATED
	var overlay_position: int = 0
	var skin_preference: String = ""
	var epilepsy_warning: bool = false
	var countdown_offset: int = 0
	var special_style: bool = false
	var widescreen_storyboard: bool = false
	var samples_match_playback_rate: bool = false


class Editor:
	var bookmarks: PackedInt32Array
	var distance_spacing: float
	var beat_divisor: int
	var grid_size: int
	var timeline_zoom: float


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


class Difficulty:
	var hp_drain_rate: float
	var circle_size: float
	var overall_difficulty: float
	var approach_rate: float
	var slider_multiplier: float
	var slider_tick_rate: float



class Background:
	var start_time: int = 0
	var event_type:int = -1
	var file_name: String
	var x_offset: int
	var y_offset: int


class Video extends Background:
	pass


class Break extends Background:
	var end_time: int


class TimingPoint:
	var time: int
	var beat_length: float
	var meter: int
	var sample_set: int
	var sample_index: int
	var volume: int = 100
	var uninherited: bool
	var effects: int

class HitObject:
	var coord: Vector2i
	var time: int
	var type:int
	var hit_sound: int = 0
	var hit_sample: HitSample

	class HitCircleObject extends HitObject:
		func _init() -> void: self.type = OsuLib.Enums.HitObject.CIRCLE

	class SliderObject extends HitObject:
		var curve_type: int
		var curve_points: PackedVector2Array
		var slides: int
		var length: float
		var edge_sounds: PackedInt32Array
		var edge_sets: Array[PackedInt32Array]
		func _init() -> void: self.type = OsuLib.Enums.HitObject.SLIDER
	
	class SpinnerObject extends HitObject:
		var end_time: int
		func _init() -> void: self.type = OsuLib.Enums.HitObject.SPINNER
			
class HitSample:
	var normal_set: int
	var addition_set: int
	var index: int = 0
	var volume: int = 100
	var file_name: String = ""


