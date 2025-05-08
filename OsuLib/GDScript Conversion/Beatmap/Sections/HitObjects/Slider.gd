class_name ISlider
extends IBeatmapHitObject


var curve_type: Enums.SliderCurve
var curve_points: PackedInt64Array
var length: float
var edge_sounds: PackedInt64Array
var edge_sets: EdgeSet


func _init() -> void:
	self.type = Enums.HitObject.SLIDER
	