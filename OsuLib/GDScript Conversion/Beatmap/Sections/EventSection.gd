class_name BeatmapEventSection
extends Beatmap


var event_type: Enums.Event
var start_time: int = 0


class Media extends BeatmapEventSection:
	var file_name: String
	var x_offset: int
	var y_offset: int


class Background extends Media:
	func _init() -> void:
		event_type = Enums.Event.BACKGROUND


class Video extends Media:
	func _init() -> void:
		event_type = Enums.Event.VIDEO


class Break extends BeatmapEventSection:
	var end_time: int
	func _init() -> void:
		event_type = Enums.Event.BREAK
