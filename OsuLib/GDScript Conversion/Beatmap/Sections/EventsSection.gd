class_name IBeatmapEvents

var event_type: Enums.Event
var start_time: int = 0


class Background extends IBeatmapEvents:
	var file_name: String
	var x_offset: int
	var y_offset: int
	func _init() -> void:
		event_type = Enums.Event.BACKGROUND


class Video extends Background:
	func _init() -> void:
		event_type = Enums.Event.VIDEO


class Break extends IBeatmapEvents:
	var end_time: int
	func _init() -> void:
		event_type = Enums.Event.BREAK

func print_data() -> void:
	var thisScript: GDScript = get_script()
	print('Properties of "%s":' % [ thisScript.resource_path ])
	for propertyInfo in thisScript.get_script_property_list():
		var propertyName: String = propertyInfo.name
		var propertyValue = get(propertyName)
		print(' %s = %s' % [ propertyName, propertyValue ])
