class_name Beatmap
extends RefCounted

func decode(p_file: String) -> void:
	if !FileAccess.file_exists(p_file):
		print("Could not find: ", p_file)
		return

	# Parse section data from file
	var file: FileAccess = FileAccess.open(p_file, FileAccess.READ)
	var format_string: String = "Parsing current_section %s"
	while file.get_position() < file.get_length():
		var line: String = file.get_line().strip_edges()
		var current_section: int = match_section(line)

		if current_section == -1:
			continue
		
		match current_section:
			Enums.Section.FORMAT:
				parse_format()
				pass
			Enums.Section.GENERAL:
				parse_general(line)
				pass
			Enums.Section.EDITOR:
				parse_editor()
				pass
			Enums.Section.METADATA:
				parse_metadata()
				pass
			Enums.Section.DIFFICULTY:
				parse_difficulty()
				pass
			Enums.Section.EVENTS:
				parse_events(line)
				pass
			Enums.Section.TIMINGPOINTS:
				parse_timing_points()
				pass
			Enums.Section.COLOURS:
				parse_colours()
				pass
			Enums.Section.HITOBJECTS:
				parse_hit_objects()
				pass

		print(format_string % Enums.Section.find_key(current_section))

		var line_arr: PackedStringArray
		if line.count(",") > 1:
			line_arr.append(line)
		else:
			continue
		for i in line_arr.size():
			line_arr[i] = line_arr[i].strip_edges()
	file.close()

static func match_section(line: String) -> int:
	line = line.strip_edges()
	var value: int = -1
	if "file" in line and "format" in line:
		value = Enums.Section.get("FORMAT")
	elif "[" in line and "]" in line:
		line = line.replace("[", "").replace("]", "").to_upper()
		value = Enums.Section.get(line)
	return value


static func parse_format() -> void:
	
	pass


static func parse_general(line: String) -> PackedStringArray:
	var general_data: PackedStringArray
	if line.count(":") == 1: # Assume key value can only have one colon in line of file
		general_data = line.split(":")

	return general_data


static func parse_editor() -> void:
	pass


static func parse_metadata() -> void:
	pass


static func parse_difficulty() -> void:
	pass


static func parse_events(line: String) -> void:
	var events_data: PackedStringArray
	if line.count(",") > 1:
		events_data.append(line)


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
