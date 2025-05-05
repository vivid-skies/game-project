class_name BeatmapParser
extends Resource


static func decode(p_file: String) -> void:
	if !FileAccess.file_exists(p_file):
		print("Could not find: ", p_file)
		return

	var file: FileAccess = FileAccess.open(p_file, FileAccess.READ)
	while file.get_position() < file.get_length():
		var line: String = file.get_line().strip_edges()
		
		# Check data is a key value pair or just the value itself
		# Assumes lines with key values can only have one colon in that line

		var count: int = 0
		for c in line:
			if c == ":":
				count += 1
		
		var line_arr: PackedStringArray
		if count == 1:
			line_arr = line.split(":")

		for i in line_arr.size():
			line_arr[i] = line_arr[i].strip_edges()
		
			print(line_arr)

		# if line == "" or line.begins_with("//"):
		# 	continue

		# # Split up the line into an array
		# # Need to check if the line contains colons or commas (if its a key value pair or just a line of data)
		# if line.begins_with("[") and line.ends_with("]"):
		# 	print(line)
		# 	continue
		
		# var line_arr = line.split(" ", 1)
		# print(line_arr)

		# if ":" in line:
		# 	var parts: PackedStringArray = line.split(":", false, 1)
		# 	for i in parts.size():
		# 		parts[i] = parts[i].strip_edges()
		# 	# print(parts)
		# 	var key: String = parts[0]
		# 	var value: String = parts[1]
			
		# 	print(key, ":", value)

		# print(line)

	file.close()


static func load_from_file(p_file: String) -> String:
	if !FileAccess.file_exists(p_file):
		return "null"
	var file: FileAccess = FileAccess.open(p_file, FileAccess.READ)
	var content: String = file.get_as_text()
	file.close()
	return content


static func save_to_file(p_file: String, content: String) -> void:
	if !FileAccess.file_exists(p_file):
		return
	var file: FileAccess = FileAccess.open(p_file, FileAccess.WRITE)
	file.store_string(content)
	file.close()

class Section:
	var length: int = 2

	pass


# [General]


# [Editor]


# [Metadata]


# [Difficulty]



# [Events]


# [TimingPoints]


# [Colours]


# [HitObjects]
