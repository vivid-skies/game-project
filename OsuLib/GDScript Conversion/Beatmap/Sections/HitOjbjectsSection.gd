class_name IBeatmapHitObjects


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


class HitCircle extends IBeatmapHitObjects:
	pass


class Sliders extends IBeatmapHitObjects:
	var curve_type: Enums.SliderCurve
	var curve_points: PackedInt64Array
	var length: float
	var edge_sounds: PackedInt64Array
	var edge_sets: EdgeSet


class EdgeSet:
	var normal_set: Enums.HitSample
	var addition_set: Enums.HitSample


class Spinner extends IBeatmapHitObjects:
	var end_time: int
	func _init() -> void:
		x = 256
		y = 192


class Holds extends IBeatmapHitObjects:
	pass
