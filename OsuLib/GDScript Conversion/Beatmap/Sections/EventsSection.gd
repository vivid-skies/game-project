class_name IBeatmapEvents
var background_events: Array[Background] = []
var video_events: Array[Video] = []
var break_events: Array[Break] = []

class Event:
	var event_type: Enums.Event
	var start_time: int = 0
	var file_name: String
	var x_offset: int
	var y_offset: int


class Background extends Event:
	func _init() -> void:
		event_type = Enums.Event.BACKGROUND


class Video extends Event:
	func _init() -> void:
		event_type = Enums.Event.VIDEO


class Break extends Event:
	var end_time: int
	func _init() -> void:
		event_type = Enums.Event.BREAK
