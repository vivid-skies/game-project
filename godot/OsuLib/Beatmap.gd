class_name Beatmap
extends Resource

# File Info
var file_format_version: int
var file_path: String
var file_name: String

# Sections
var general: General
var editor: Editor
var metadata: Metadata
var difficulty: Difficulty
# Events
var background_events: Array[Background]
var video_events: Array[Video]
var break_events: Array[Break]
# Timing Points
var timing_points: Array[Dictionary]
# Colours
var combo_colours: Array[PackedInt32Array]
var slider_track_override: PackedInt32Array
var slider_border: PackedInt32Array
# HitObjects
var hit_objects: Array

func _init() -> void:
	general = General.new()
	editor = Editor.new()
	metadata = Metadata.new()
	difficulty = Difficulty.new()

func get_file_info() -> Dictionary:
	return {
		file_format_version = self.file_format_version,
		file_path = self.file_path,
		file_name = self.file_name,
	}

func get_general() -> Dictionary:
	return {
		audio_file_name = self.general.audio_file_name,
		audio_lead_in = self.general.audio_lead_in,
		audio_hash = self.general.audio_hash, # DEPRECATED
		preview_time = self.general.preview_time,
		countdown = self.general.countdown,
		sample_set = self.general.sample_set,
		stack_leniency = self.general.stack_leniency,
		mode = self.general.mode,
		letterbox_in_breaks = self.general.letterbox_in_breaks,
		story_fire_in_front = self.general.story_fire_in_front, # DEPRECATED
		use_skin_sprites = self.general.use_skin_sprites,
		always_show_playfield = self.general.always_show_playfield, # DEPRECATED
		overlay_position = self.general.overlay_position,
		skin_preference = self.general.skin_preference,
		epilepsy_warning = self.general.epilepsy_warning,
		countdown_offset = self.general.countdown_offset,
		special_style = self.general.special_style,
		widescreen_storyboard = self.general.widescreen_storyboard,
		samples_match_playback_rate = self.general.samples_match_playback_rate,
	}

func get_editor() -> Dictionary:
	return {
		bookmarks = self.editor.bookmarks,
		distance_spacing = self.editor.distance_spacing,
		beat_divisor = self.editor.beat_divisor,
		grid_size = self.editor.grid_size,
		timeline_zoom = self.editor.timeline_zoom,
	}

func get_metadata() -> Dictionary:
	return {
		title = self.metadata.title,
		title_unicode = self.metadata.title_unicode,
		artist = self.metadata.artist,
		artist_unicode = self.metadata.artist_unicode,
		creator = self.metadata.creator,
		version = self.metadata.version,
		source = self.metadata.source,
		tags = self.metadata.tags,
		beatmap_id = self.metadata.beatmap_id,
		beatmap_set_id = self.metadata.beatmap_set_id,
	}

func get_difficulty() -> Dictionary:
	return {
		hp_drain_rate = self.difficulty.hp_drain_rate,
		circle_size = self.difficulty.circle_size,
		overall_difficulty = self.difficulty.overall_difficulty,
		approach_rate = self.difficulty.approach_rate,
		slider_multiplier = self.difficulty.slider_multiplier,
		slider_tick_rate = self.difficulty.slider_tick_rate,
	}

func get_background() -> Dictionary:
	return {
		background_events = self.background_events,
		video_events = self.video_events,
		break_events = self.break_events,
	}

func get_colours() -> Dictionary:
	return {
		combo_colours = self.combo_colours,
		slider_track_override = self.slider_track_override,
		slider_border = self.slider_border,
	}

func get_timing_points() -> Array[Dictionary]:
	return self.timing_points


func get_hit_objects() -> Array:
	# var hit_objects_dict: Array[Dictionary]

	# for i in hit_objects.size():
	# 	hit_objects_dict.append(
	# 		{

	# 		}
	# 	)
	return self.hit_objects



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
	const DEFAULT_BEAT_LENGTH = 60000.0 / 60.0 # 1000

	var time: int
	var beat_length: float
	var meter: int
	var sample_set: int
	var sample_index: int
	var volume: int = 100
	var uninherited: int
	var effects: int

	var data: Dictionary:
		get:
			return {
				time = self.time,
				beat_length = self.beat_length,
				meter = self.meter,
				sample_set = self.sample_set,
				sample_index = self.sample_index,
				volume = self.volume,
				uninherited = self.uninherited,
				effects = self.effects,
			}

	var bpm : float:
		get: return 60000.0 / beat_length if beat_length > 0 else DEFAULT_BEAT_LENGTH


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
