class_name Beatmap
extends RefCounted

# [GENERAL]
var beatmap_file: String
# Parsed data from .osu file into data holder classes
# Unsure if I should have used dictionaries instead but I wanted typed safety
var file_format_version: int
var general: IBeatmapGeneral = IBeatmapGeneral.new()
var editor: IBeatmapEditor = IBeatmapEditor.new()
var metadata: IBeatmapMetadata = IBeatmapMetadata.new()
var difficulty: IBeatmapDifficulty = IBeatmapDifficulty.new()
var background_events: Array[IBeatmapEvents.Background] = []
var video_events: Array[IBeatmapEvents.Video] = []
var break_events: Array[IBeatmapEvents.Break] = []
var timing_points: Array[IBeatmapTimingPoint] = []
var combo_colours: Array[IBeatmapColours] = []
var slider_track_override: IBeatmapColours = IBeatmapColours.new()
var slider_border: IBeatmapColours = IBeatmapColours.new()
var hit_objects: Array[IBeatmapHitObject] = []


func decode(p_file: String) -> void:
	if !FileAccess.file_exists(p_file):
		print("Could not find: ", p_file)
		return
	# Parse section data from file
	var file: FileAccess = FileAccess.open(p_file, FileAccess.READ)
	var current_section: Enums.Section = Enums.Section.NONE

	#  Loops over each line in the .osu file for parsing
	while file.get_position() < file.get_length():
		var line: String = file.get_line().strip_edges()
		if line.is_empty():
			continue
		# Checks if line denotes a section or data
		if "file" in line and "format" in line:
			var line_arr: PackedStringArray = line.split(" ")
			self.file_format_version = line_arr[3].replacen("v", "").strip_edges() as int
			# print("Version: ", self.file_format_version)
			continue
		elif "[" in line and "]" in line:
			var line_cleaned: String = line.replace("[", "").replace("]", "").to_upper() 
			# print(line_cleaned)
			current_section = Enums.Section.get(line_cleaned)
			continue
		# Check if line of file denotes a section or data
		# Sections in .osu files are written like [SECTION]
		var line_array: PackedStringArray
		var key: String
		var value: Variant
		# Read each line
		# Add value to array until next section
		# Then parse the entire array
		var format_string: String = "Parsing current_section %s"
		# if not current_section == Enums.Section.NONE:
		# 	print(format_string % Enums.Section.find_key(current_section))
		match current_section:
			Enums.Section.GENERAL:
				line_array = line.split(":") # Assume key value can only have one colon in line of file
				for i in line_array.size():
					line_array[i] = line_array[i].strip_edges()
				key = line_array[0]
				value = line_array[1]
				# print(key, ": ", value)
				match key.to_upper():
					"AUDIOFILENAME":
						self.general.audio_file_name = value as String
					"AUDIOLEADIN":
						self.general.audio_lead_in = value as int
					"PREVIEWTIME":
						self.general.preview_time = value as int
					"COUNTDOWN":
						self.general.countdown = value.to_int() as Enums.Countdown
					"SAMPLESET":
						self.general.sample_set = value.to_int() as Enums.SampleSet
					"STACKLENIENCY":
						self.general.stack_leniency = value as float
					"MODE":
						self.general.mode = value.to_int() as Enums.Mode
					"LETTERBOXINBREAKS":
						self.general.letterbox_in_breaks = value.to_int() as bool
					"WIDESCREENSTORYBOARD":
						self.general.widescreen_storyboard  = value.to_int() as bool
			Enums.Section.EDITOR:
				line_array = line.split(":") # Assume key value can only have one colon in line of file
				for i in line_array.size():
					line_array[i] = line_array[i].strip_edges()
				key = line_array[0]
				value = line_array[1]
				match key.to_upper():
					"BOOKMARKS":
						var bookmark_array: PackedInt32Array
						for i: int in value.size():
							bookmark_array.append(value[i].to_int())
						self.editor.bookmarks = bookmark_array
					"DISTANCESPACING":
						self.editor.distance_spacing = value as float
					"BEATDIVISOR":
						self.editor.beat_divisor = value as int
					"GRIDSIZE":
						self.editor.grid_size = value as int
					"TIMELINEZOOM":
						self.editor.timeline_zoom = value as float
			Enums.Section.METADATA:
				line_array = line.split(":") # Assume key value can only have one colon in line of file
				for i in line_array.size():
					line_array[i] = line_array[i].strip_edges()
				key = line_array[0]
				value = line_array[1]
				match key.to_upper():
					"TITLE":
						self.metadata.title = value as String
					"TITLEUNICODE":
						self.metadata.title_unicode = value as String
					"ARTIST":
						self.metadata.artist = value as String
					"ARTISTUNICODE":
						self.metadata.artist_unicode = value as String
					"CREATOR":
						self.metadata.creator = value as String
					"VERSION":
						self.metadata.version = value as String
					"SOURCE":
						self.metadata.source = value as String
					"TAGS":
						self.metadata.tags = value.split(" ") as PackedStringArray
					"BEATMAPID":
						self.metadata.beatmap_id = value as int
					"BEATMAPSETID":
						self.metadata.beatmap_set_id = value as int
			Enums.Section.DIFFICULTY:
				line_array = line.split(":") # Assume key value can only have one colon in line of file
				for i in line_array.size():
					line_array[i] = line_array[i].strip_edges()
				key = line_array[0]
				value = line_array[1]
				match key.to_upper():
					"HPDRAINRATE":
						self.difficulty.hp_drain_rate = value as float
					"CIRCLESIZE":
						self.difficulty.circle_size = value as float
					"OVERALLDIFFICULTY":
						self.difficulty.overall_difficulty = value as float
					"APPROACHRATE":
						self.difficulty.approach_rate = value as float
					"SLIDERMULTIPLIER":
						self.difficulty.slider_multiplier = value as float
					"SLIDERTICKRATE":
						self.difficulty.slider_tick_rate = value as float
			Enums.Section.EVENTS:
				# The event section has its own sub sections in them, so we need ot loop over each sub-section			
				if "//" in line: 
					continue
				line_array = line.split(",")
				for i in line_array.size():
					line_array[i] = line_array[i].strip_edges()
				var event_type: Enums.Event = line_array[0].to_int() as Enums.Event
				match event_type:
					Enums.Event.BACKGROUND:
						var background_event: IBeatmapEvents.Background = IBeatmapEvents.Background.new()
						background_event.start_time = line_array[1] as int
						background_event.file_name = line_array[2] as String
						background_event.x_offset = line_array[3] as int
						background_event.y_offset = line_array[4] as int
						self.background_events.append(background_event)
					Enums.Event.VIDEO:
						var video_event: IBeatmapEvents.Video = IBeatmapEvents.Video.new()
						video_event.start_time = line_array[1] as int
						video_event.file_name = line_array[2] as String
						video_event.x_offset = line_array[3] as int
						video_event.y_offset = line_array[4] as int
						self.video_events.append(video_event)
					Enums.Event.BREAK:
						var break_event: IBeatmapEvents.Break = IBeatmapEvents.Break.new()
						break_event.start_time = line_array[1] as int
						break_event.end_time = line_array[2] as int
						self.break_events.append(break_event)
					Enums.Event.STORYBOARD: # Unsupported
						continue
			Enums.Section.TIMINGPOINTS:
				line_array = line.split(',')
				for i in line_array.size():
					line_array[i] = line_array[i].strip_edges()
				var timing_point: IBeatmapTimingPoint = IBeatmapTimingPoint.new()
				timing_point.time = line_array[0] as int
				timing_point.beat_length = line_array[1] as float
				timing_point.meter = line_array[2] as int
				timing_point.sample_set = line_array[3].to_int() as Enums.SampleSet
				timing_point.sample_index = line_array[4] as int
				timing_point.volume = line_array[5] as int
				timing_point.uninherited = line_array[6].to_int() as bool
				timing_point.effects = line_array[7].to_int() as Enums.Effect
				self.timing_points.append(timing_point)
			Enums.Section.COLOURS:
				line_array = line.split(':')
				for i in line_array.size():
					line_array[i] = line_array[i].strip_edges()

				key = line_array[0].to_upper()
				value = line_array[1].split(",")

				var rgb: PackedInt32Array = []
				for i: int in value.size():
					rgb.append(value[i].strip_edges().to_int())

				match key:
					"SLIDERTRACKOVERRIDE":
						self.slider_track_override.rgb = rgb
					"SLIDERBORDER":
						self.slider_border.rgb = rgb
					_:
						var combo_colour: IBeatmapColours = IBeatmapColours.new()
						combo_colour.rgb = rgb
						self.combo_colours.append(combo_colour)	
			Enums.Section.HITOBJECTS:
				line_array = line.split(',')
				for i in line_array.size():
					line_array[i] = line_array[i].strip_edges()
				var data_length: int = line_array.size()
				if data_length == 6:
					var hit_circle: IHitCircle = IHitCircle.new()
					hit_circle.hit_sample = IHitSample.new()
					var hit_sample_arr: PackedStringArray = line_array[5].split(":")
					for i in hit_sample_arr.size():
						hit_sample_arr[i] = hit_sample_arr[i].strip_edges()
					hit_circle.hit_sample.normal_set = hit_sample_arr[0].to_int() as Enums.HitSample
					hit_circle.hit_sample.addition_set = hit_sample_arr[1].to_int() as Enums.HitSample
					hit_circle.hit_sample.index = hit_sample_arr[2] as int
					hit_circle.hit_sample.volume = hit_sample_arr[3] as int
					hit_circle.hit_sample.file_name = hit_sample_arr[4] if hit_sample_arr.size() == 5 else ""

					hit_circle.x = line_array[0] as int
					hit_circle.y = line_array[1] as int
					hit_circle.time = line_array[2] as int
					hit_circle.type = line_array[3].to_int() as Enums.HitObject 
					hit_circle.hit_sound = line_array[4].to_int() as Enums.HitSound

					hit_objects.append(hit_circle)
				elif data_length == 7:
						var spinner: ISpinner = ISpinner.new()
						spinner.hit_sample = IHitSample.new()
						var hit_sample_arr: PackedStringArray = line_array[6].split(":")
						for i in hit_sample_arr.size():
							hit_sample_arr[i] = hit_sample_arr[i].strip_edges()
						spinner.hit_sample.normal_set = hit_sample_arr[0].to_int() as Enums.HitSample
						spinner.hit_sample.addition_set = hit_sample_arr[1].to_int() as Enums.HitSample
						spinner.hit_sample.index = hit_sample_arr[2] as int
						spinner.hit_sample.volume = hit_sample_arr[3] as int
						spinner.hit_sample.file_name = hit_sample_arr[4] if hit_sample_arr.size() == 5 else ""

						spinner.x = line_array[0] as int
						spinner.y = line_array[1] as int
						spinner.time = line_array[2] as int
						spinner.type = line_array[3].to_int() as Enums.HitObject 
						spinner.hit_sound = line_array[4].to_int() as Enums.HitSound
						spinner.end_time = line_array[5] as int

						hit_objects.append(spinner)
				else:
					match line_array[5]:
						"L": # Linear Curve
							
							pass
						"P": # Perfect Circle
							pass
						"B": # Bezier
							pass
						"C": # Centripetal (LEGACY)
							pass
					pass

				# slider.curve_type = line_array[5] 
				# hit_object.x = line_array[0] as int
				# hit_object.y = line_array[1] as int
				# hit_object.time = line_array[2] as int
				# hit_object.type = line_array[3].to_int() as Enums.HitObject
				# hit_object.hit_sound = line_array[4].to_int() as Enums.HitSound

				
				
		# print(format_string % Enums.Section.find_key(current_section))

	file.close()

func _format_data() -> void:
	pass

	
func match_section() -> void:
	pass


static func parse_format() -> void:
	
	pass


static func parse_general() -> void:
	pass


static func parse_editor() -> void:
	pass


static func parse_metadata() -> void:
	pass


static func parse_difficulty() -> void:
	pass


static func parse_events() -> void:
	pass

static func parse_timing_points() -> void:
	pass


static func parse_colours() -> void:
	pass


static func parse_hit_objects() -> void:
	pass


static func parse_hit_samples() -> void:
	pass


static func read_from_file() -> void:
	pass



static func save_to_file(p_file: String, content: String) -> void:
	if !FileAccess.file_exists(p_file):
		return
	var file: FileAccess = FileAccess.open(p_file, FileAccess.WRITE)
	file.store_string(content)
	file.close()

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



# [HitObject]
