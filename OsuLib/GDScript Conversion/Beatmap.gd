class_name Beatmap
extends RefCounted

var beatmap_file: String

# Parsed data from .osu file into data holder classes
# Unsure if I should have used dictionaries instead but I wanted typed safety
var file_format_version: int
var general: IBeatmapGeneral = IBeatmapGeneral.new()
var editor: IBeatmapEditor = IBeatmapEditor.new()
var metadata: IBeatmapMetadata = IBeatmapMetadata.new()
var difficulty: IBeatmapDifficulty = IBeatmapDifficulty.new()
var events: IBeatmapEvents = IBeatmapEvents.new()
var timing_points: IBeatmapTimingPoints = IBeatmapTimingPoints.new()
var colours: IBeatmapColours = IBeatmapColours.new()
var hit_objects: IBeatmapHitObjects = IBeatmapHitObjects.new()

var dict: Dictionary[int, String] = {
	2: "3",
	3: "2",
}

func test() -> void:
	print(dict)
	print(dict[2])

func decode(p_file: String) -> void:
	if !FileAccess.file_exists(p_file):
		print("Could not find: ", p_file)
		return

	# Parse section data from file
	var file: FileAccess = FileAccess.open(p_file, FileAccess.READ)
	var format_string: String = "Parsing current_section %s"
	var current_section: Enums.Section
	var event_subsection: Enums.Event
	var event_subsection_accumulator: int = 0
	
	#  Loops over each line in the .osu file for parsing
	while file.get_position() < file.get_length():
		var line: String = file.get_line().strip_edges()
		var current_section_enum: int = -1
		# Checks if line denotes a section or data
		if "file" in line and "format" in line:
			var line_arr: PackedStringArray = line.split(" ")
			self.file_format_version = line_arr[3].replacen("v", "").strip_edges() as int
			continue
		elif "[" in line and "]" in line:
			var line_cleaned: String = line.replace("[", "").replace("]", "").to_upper() 
			current_section_enum = Enums.Section.get(line_cleaned)
			current_section = Enums.Section.find_key(current_section_enum)
			continue
		# Check if line of file denotes a section or data
		# Sections in .osu files are written like [SECTION]
		var section_data: PackedStringArray

		match current_section as Enums.Section:
			Enums.Section.GENERAL:
				section_data = line.split(":") # Assume key value can only have one colon in line of file
				
				if section_data.size() > 8:
					push_error("Array size of general section exceeds 8, please review Beatmap.gd source")
					print(section_data)
					continue				
				
				for i in section_data.size():
					section_data[i] = section_data[i].strip_edges()

				self.general.audio_file_name = section_data[0] as String
				self.general.audio_lead_in = section_data[1] as int
				self.general.preview_time = section_data[2] as int
				self.general.countdown = section_data[3].to_int() as Enums.Countdown
				self.general.sample_set = section_data[4].to_int() as Enums.SampleSet
				self.general.stack_leniency = section_data[5] as float
				self.general.mode = section_data[6].to_int() as Enums.Mode
				self.general.letterbox_in_breaks = section_data[7] as bool
				self.general.widescreen_storyboard  = section_data[8] as bool

			Enums.Section.EDITOR:

				section_data = line.split(":") # Assume key value can only have one colon in line of file
				
				if section_data.size() > 4:
					push_error("Array size of editor section exceeds 4, please review Beatmap.gd source")
					print(section_data)
					continue				
				for i in section_data.size():
					section_data[i] = section_data[i].strip_edges()
				
				self.editor.distance_spacing = section_data[0] as float
				self.editor.beat_divisor = section_data[1] as int
				self.editor.grid_size = section_data[2] as int
				self.editor.timeline_zoom = section_data[3] as float

			Enums.Section.METADATA:
				section_data = line.split(":") # Assume key value can only have one colon in line of file
				
				if section_data.size() > 10:
					push_error("Array size of metadata section exceeds 10, please review Beatmap.gd source")
					print(section_data)
					continue				
				for i in section_data.size():
					section_data[i] = section_data[i].strip_edges()

				self.metadata.title = section_data[0] as String
				self.metadata.title_unicode = section_data[1] as String
				self.metadata.artist = section_data[2] as String
				self.metadata.artist_unicode = section_data[3] as String
				self.metadata.creator = section_data[4] as String
				self.metadata.version = section_data[5] as String
				self.metadata.source = section_data[6] as String
				self.metadata.tags = section_data[7].split(" ") as PackedStringArray
				self.metadata.beatmap_id = section_data[8] as int
				self.metadata.beatmap_set_id = section_data[9] as int

			Enums.Section.DIFFICULTY:
				section_data = line.split(":") # Assume key value can only have one colon in line of file
				
				if section_data.size() > 6:
					push_error("Array size of difficulty section exceeds 6 please review Beatmap.gd source")
					print(section_data)
					continue
				for i in section_data.size():
					section_data[i] = section_data[i].strip_edges()

				self.difficulty.hp_drain_rate = section_data[0] as float
				self.difficulty.circle_size = section_data[1] as float
				self.difficulty.overall_difficulty = section_data[2] as float
				self.difficulty.approach_rate = section_data[3] as float
				self.difficulty.slider_multiplier = section_data[4] as float
				self.difficulty.slider_tick_rate = section_data[5] as float

			Enums.Section.EVENTS:
				# The event section has its own sub sections in them, so we need ot loop over each sub-section			
				if "//" in line: 
					event_subsection = Enums.Event.find_key(event_subsection_accumulator)
					event_subsection_accumulator += 1
					continue
				
				section_data = line.split(",")

				for i in section_data.size():
					section_data[i] = section_data[i].strip_edges()
			
				match section_data[0].to_int() as Enums.Event:
					Enums.Event.BACKGROUND:
						if section_data.size() > 5:
							push_error("Array size of background section exceeds 6 please review Beatmap.gd source")
							print(section_data)
							continue							
						
						var background_event: IBeatmapEvents.Background = IBeatmapEvents.Background.new()
						background_event.start_time = section_data[1] as int
						background_event.file_name = section_data[2] as String
						background_event.x_offset = section_data[3] as int
						background_event.y_offset = section_data[4] as int
						self.events.background_events.append(background_event)

					Enums.Event.VIDEO:
						if section_data.size() > 5:
							push_error("Array size of video section exceeds 6 please review Beatmap.gd source")
							print(section_data)
							continue	
						
						var video_event: IBeatmapEvents.Video = IBeatmapEvents.Video.new()
						video_event.start_time = section_data[1] as int
						video_event.file_name = section_data[2] as String
						video_event.x_offset = section_data[3] as int
						video_event.y_offset = section_data[4] as int
						self.events.video_events.append(video_event)

					Enums.Event.BREAK:
						if section_data.size() > 3:
							push_error("Array size of breaks section exceeds 6 please review Beatmap.gd source")
							print(section_data)
							continue							
						var break_event: IBeatmapEvents.Break = IBeatmapEvents.Break.new()
						break_event.start_time = section_data[1] as int
						break_event.end_time = section_data[2] as int
						self.events.break_events.append(break_event)

					Enums.Event.STORYBOARD:
						# No support for storyboard for now so just skip the line
						if event_subsection == Enums.Event.STORYBOARD:
							continue

			Enums.Section.TIMINGPOINTS:
				parse_timing_points()
				pass
			Enums.Section.COLOURS:
				parse_colours()
				pass
			Enums.Section.HITOBJECTS:
				parse_hit_objects()
				pass

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
