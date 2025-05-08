class_name ISpinner
extends IBeatmapHitObject


var end_time: int


func _init() -> void:
	self.type = Enums.HitObject.SPINNER
	x = 256
	y = 192
