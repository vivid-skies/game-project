

class Decode:
	static func beatmap_decode(p_file: String) -> Beatmap:
		if !FileAccess.file_exists(p_file):
			push_error("Could not find: ", p_file)
			return

		var file: FileAccess = FileAccess.open(p_file, FileAccess.READ)
		var beatmap: Beatmap = Beatmap.new()
		beatmap.file_path = p_file
		var current_section: int = 0
		
		while file.get_position() < file.get_length():
			var line: String = file.get_line().strip_edges()
			if line.is_empty(): continue
			elif "file" in line and "format" in line:
				var line_arr: PackedStringArray = line.split(" ")
				beatmap.file_format_version = line_arr[3].replacen("v", "").strip_edges() as int
				continue
			elif "[" in line and "]" in line:
				var line_cleaned: String = line.replace("[", "").replace("]", "").to_upper() 
				current_section = OsuLib.Enums.Section.get(line_cleaned)
				continue
			match current_section:
				OsuLib.Enums.Section.GENERAL: parse_general(beatmap.general, line)
				OsuLib.Enums.Section.EDITOR: parse_editor(beatmap.editor, line)
				OsuLib.Enums.Section.METADATA: parse_metadata(beatmap.metadata, line)
				OsuLib.Enums.Section.DIFFICULTY: parse_difficulty(beatmap.difficulty, line)
				OsuLib.Enums.Section.EVENTS: parse_events(beatmap.background_events, beatmap.video_events, beatmap.break_events, line)
				OsuLib.Enums.Section.TIMINGPOINTS: parse_timing_points(beatmap.timing_points, line)
				OsuLib.Enums.Section.COLOURS: parse_colours(beatmap.combo_colours, beatmap.slider_track_override, beatmap.slider_border, line)
				OsuLib.Enums.Section.HITOBJECTS: parse_hit_objects(beatmap.hit_objects, line)
		file.close()
		print("Beatmap succesfully decoded")
		return beatmap


	static func parse_general(general: Beatmap.General, line: String) -> void:
		var contents: PackedStringArray  = line.split(":")
		for i in contents.size(): contents[i] = contents[i].strip_edges()
		var key: String = contents[0].to_upper()
		var value: String = contents[1]
		match key:
			"AUDIOFILENAME": general.audio_file_name = value as String
			"AUDIOLEADIN": general.audio_lead_in = value as int
			"PREVIEWTIME": general.preview_time = value as int
			"COUNTDOWN": general.countdown = value as int
			"SAMPLESET": general.sample_set = value as int
			"STACKLENIENCY": general.stack_leniency = value as float
			"MODE": general.mode = value.to_int() as OsuLib.Enums.Mode
			"LETTERBOXINBREAKS": general.letterbox_in_breaks = value.to_int() as bool
			"WIDESCREENSTORYBOARD": general.widescreen_storyboard  = value.to_int() as bool
	

	static func parse_editor(editor: Beatmap.Editor, line: String) -> void:
		var contents: PackedStringArray = line.split(":")
		for i in contents.size(): contents[i] = contents[i].strip_edges()
		var key: String = contents[0].to_upper()
		var value: Variant = contents[1]
		var bookmark_array: PackedInt32Array
		match key:
			"BOOKMARKS":
				value = value.split(',')
				for i: int in value.size(): bookmark_array.append(value[i].to_int())
				editor.bookmarks = bookmark_array as PackedInt32Array
			"DISTANCESPACING": editor.distance_spacing = value as float
			"BEATDIVISOR": editor.beat_divisor = value as int
			"GRIDSIZE": editor.grid_size = value as int
			"TIMELINEZOOM": editor.timeline_zoom = value as float


	static func parse_metadata(metadata: Beatmap.Metadata, line: String) -> void:
		var contents: PackedStringArray = line.split(":")
		for i in contents.size(): contents[i] = contents[i].strip_edges()
		var key: String = contents[0].to_upper()
		var value: String = contents[1]
		match key:
			"TITLE": metadata.title = value as String
			"TITLEUNICODE": metadata.title_unicode = value as String
			"ARTIST": metadata.artist = value as String
			"ARTISTUNICODE": metadata.artist_unicode = value as String
			"CREATOR": metadata.creator = value as String
			"VERSION": metadata.version = value as String
			"SOURCE": metadata.source = value as String
			"TAGS": metadata.tags = value.split(" ") as PackedStringArray
			"BEATMAPID": metadata.beatmap_id = value as int
			"BEATMAPSETID": metadata.beatmap_set_id = value as int


	static func parse_difficulty(difficulty: Beatmap.Difficulty, line: String) -> void:
		var contents: PackedStringArray = line.split(":")
		for i in contents.size(): contents[i] = contents[i].strip_edges()
		var key: String = contents[0].to_upper()
		var value: String = contents[1]
		match key:
			"HPDRAINRATE": difficulty.hp_drain_rate = value as float
			"CIRCLESIZE": difficulty.circle_size = value as float
			"OVERALLDIFFICULTY": difficulty.overall_difficulty = value as float
			"APPROACHRATE": difficulty.approach_rate = value as float
			"SLIDERMULTIPLIER": difficulty.slider_multiplier = value as float
			"SLIDERTICKRATE": difficulty.slider_tick_rate = value as float


	static func parse_events(background_events: Array[Beatmap.Background], video_events: Array[Beatmap.Video], break_events: Array[Beatmap.Break], line: String) -> void:
		if "//" in line: return

		var contents: PackedStringArray = line.split(",")
		for i in contents.size(): contents[i] = contents[i].strip_edges()

		var event_type: int = contents[0].to_int()
		match event_type:
			OsuLib.Enums.Event.BACKGROUND:
				var background_event: Beatmap.Background = Beatmap.Background.new()
				background_event.start_time = contents[1] as int
				background_event.file_name = contents[2] as String
				background_event.x_offset = contents[3] as int
				background_event.y_offset = contents[4] as int
				background_events.append(background_event)
			OsuLib.Enums.Event.VIDEO:
				var video_event: Beatmap.Video = Beatmap.Video.new()
				video_event.start_time = contents[1] as int
				video_event.file_name = contents[2] as String
				video_event.x_offset = contents[3] as int
				video_event.y_offset = contents[4] as int
				video_events.append(video_event)
			OsuLib.Enums.Event.BREAK:
				var break_event: Beatmap.Break = Beatmap.Break.new()
				break_event.start_time = contents[1] as int
				break_event.end_time = contents[2] as int
				break_events.append(break_event)
			OsuLib.Enums.Event.STORYBOARD: # Unsupported
				return


	static func parse_timing_points(timing_points: Array[Beatmap.TimingPoint], line: String) -> void:
		var contents: PackedStringArray = line.split(',')
		for i in contents.size(): contents[i] = contents[i].strip_edges()
		var timing_point: Beatmap.TimingPoint = Beatmap.TimingPoint.new()
		timing_point.time = contents[0] as int
		timing_point.beat_length = contents[1] as float
		timing_point.meter = contents[2] as int
		timing_point.sample_set = contents[3].to_int() as OsuLib.Enums.SampleSet
		timing_point.sample_index = contents[4] as int
		timing_point.volume = contents[5] as int
		timing_point.uninherited = contents[6].to_int() as bool
		timing_point.effects = contents[7].to_int() as OsuLib.Enums.Effect
		timing_points.append(timing_point)


	static func parse_colours(combo_colours: Array[PackedInt32Array], _slider_track_override: PackedInt32Array, _slider_border: PackedInt32Array, line: String) -> void:
		var contents: PackedStringArray = line.split(':')
		for i in contents.size(): contents[i] = contents[i].strip_edges()
		var key: String = contents[0].to_upper()
		var value: PackedStringArray = contents[1].split(",")
		var rgb: PackedInt32Array
		for i in value.size(): rgb.append(value[i].strip_edges().to_int())
		match key:
			"SLIDERTRACKOVERRIDE": _slider_track_override = rgb
			"SLIDERBORDER": _slider_border = rgb
			_: combo_colours.append(rgb)


	static func parse_hit_objects(hit_objects: Array, line: String) -> void:
		var contents: PackedStringArray = line.split(',')
		for i in contents.size(): contents[i] = contents[i].strip_edges()
		match contents.size():
			6:
				var hit_circle: Beatmap.HitObject.HitCircleObject = parse_hit_circle(contents)
				hit_objects.append(hit_circle)
			7:
				var spinner: Beatmap.HitObject.SpinnerObject = Beatmap.HitObject.SpinnerObject.new()
				hit_objects.append(spinner)
			11: 
				var slider: Beatmap.HitObject.SliderObject = parse_slider(contents)
				hit_objects.append(slider)
	

	static func parse_hit_circle(contents: PackedStringArray) -> Beatmap.HitObject.HitCircleObject:
		var hit_circle: Beatmap.HitObject.HitCircleObject = Beatmap.HitObject.HitCircleObject.new()

		hit_circle.hit_sample = Beatmap.HitSample.new()
		var hit_sample_arr: PackedStringArray = contents[5].split(":")
		for i in hit_sample_arr.size(): hit_sample_arr[i] = hit_sample_arr[i].strip_edges()
		
		hit_circle.hit_sample.normal_set = hit_sample_arr[0].to_int() as OsuLib.Enums.HitSample
		hit_circle.hit_sample.addition_set = hit_sample_arr[1].to_int() as OsuLib.Enums.HitSample
		hit_circle.hit_sample.index = hit_sample_arr[2] as int
		hit_circle.hit_sample.volume = hit_sample_arr[3] as int
		hit_circle.hit_sample.file_name = hit_sample_arr[4] if hit_sample_arr.size() == 5 else ""

		hit_circle.coord.x = contents[0] as int
		hit_circle.coord.y = contents[1] as int
		hit_circle.time = contents[2] as int
		hit_circle.type = contents[3] as int
		hit_circle.hit_sound = contents[4] as int

		return hit_circle


	static func parse_spinner(contents: PackedStringArray) -> Beatmap.HitObject.SpinnerObject:
		var spinner: Beatmap.HitObject.SpinnerObject = Beatmap.HitObject.SpinnerObject.new()
		
		spinner.hit_sample = Beatmap.HitSample.new()
		var hit_sample_arr: PackedStringArray = contents[6].split(":")
		for i in hit_sample_arr.size(): hit_sample_arr[i] = hit_sample_arr[i].strip_edges()

		spinner.hit_sample.normal_set = hit_sample_arr[0] as int
		spinner.hit_sample.addition_set = hit_sample_arr[1] as int
		spinner.hit_sample.index = hit_sample_arr[2] as int
		spinner.hit_sample.volume = hit_sample_arr[3] as int
		spinner.hit_sample.file_name = hit_sample_arr[4] if hit_sample_arr.size() == 5 else ""

		spinner.coord.x = contents[0] as int
		spinner.coord.y = contents[1] as int
		spinner.time = contents[2] as int
		spinner.type = contents[3] as int
		spinner.hit_sound = contents[4] as int
		spinner.end_time = contents[5] as int

		return spinner
	

	static func parse_slider(contents: PackedStringArray) -> Beatmap.HitObject.SliderObject:
		var slider: Beatmap.HitObject.SliderObject = Beatmap.HitObject.SliderObject.new()
		var curve_data: PackedStringArray = contents[5].split("|")
		var curve_type: OsuLib.Enums.CurveType
		var curve_points: PackedVector2Array
		var edge_sound_data: PackedStringArray
		var edge_sounds: PackedInt32Array
		var edge_set_data: PackedStringArray = contents[9].split("|")
		var edge_sets: Array[PackedInt32Array]

		match curve_data[0]:
			"L": # Linear Curve
				curve_type = OsuLib.Enums.CurveType.LINEAR
			"P": # Perfect Circle
				curve_type = OsuLib.Enums.CurveType.PERFECT_CIRCLE
			"B": # Bezier
				curve_type = OsuLib.Enums.CurveType.BEZIER
			"C": # Centripetal (LEGACY) / DEPRECATED
				curve_type = OsuLib.Enums.CurveType.CENTRIPETAL

		for i in range(1, curve_data.size()):
			var curve_point: PackedStringArray = curve_data[i].split(":")
			var coords: Vector2i
			coords.x = curve_point[0] as int
			coords.y = curve_point[1] as int
			curve_points.append(coords)

		for i in edge_sound_data.size():
			var edge_sound: int = edge_sound_data[i] as int
			edge_sounds.append(edge_sound)

		for i in edge_set_data.size():
			var edge_set_contents: PackedStringArray = edge_set_data[i].split(":")
			var edge_set: PackedInt32Array
			edge_set.append(edge_set_contents[0].to_int())
			edge_set.append(edge_set_contents[1].to_int())
			edge_sets.append(edge_set)

		slider.hit_sample = Beatmap.HitSample.new()
		var hit_sample_arr: PackedStringArray = contents[10].split(":")
		for i in hit_sample_arr.size(): hit_sample_arr[i] = hit_sample_arr[i].strip_edges()

		slider.hit_sample.normal_set = hit_sample_arr[0] as int
		slider.hit_sample.addition_set = hit_sample_arr[1] as int
		slider.hit_sample.index = hit_sample_arr[2] as int
		slider.hit_sample.volume = hit_sample_arr[3] as int
		slider.hit_sample.file_name = hit_sample_arr[4] if hit_sample_arr.size() == 5 else ""

		slider.coord.x = contents[0] as int
		slider.coord.y = contents[1] as int
		slider.time = contents[2] as int
		slider.type = contents[3] as int
		slider.hit_sound = contents[4] as int	
		slider.curve_type = curve_type # contents[5]
		slider.curve_points = curve_points # contents[5]
		slider.slides = contents[6] as int
		slider.length = contents[7] as float
		slider.edge_sounds = edge_sounds # contents[8]
		slider.edge_sets = edge_sets # contents[9]

		return slider


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

	pass
