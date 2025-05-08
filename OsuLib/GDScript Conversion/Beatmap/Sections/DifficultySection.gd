class_name IBeatmapDifficulty


var hp_drain_rate: float
var circle_size: float
var overall_difficulty: float
var approach_rate: float
var slider_multiplier: float
var slider_tick_rate: float

func print_data() -> void:
	var thisScript: GDScript = get_script()
	print('Properties of "%s":' % [ thisScript.resource_path ])
	for propertyInfo in thisScript.get_script_property_list():
		var propertyName: String = propertyInfo.name
		var propertyValue = get(propertyName)
		print(' %s = %s' % [ propertyName, propertyValue ])
