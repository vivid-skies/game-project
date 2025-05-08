class_name IBeatmapTimingPoint


var time: int
var beat_length: float
var meter: int
var sample_set: Enums.SampleSet = Enums.SampleSet.NONE
var sample_index: int
var volume: int = 100
var uninherited: bool
var effects: Enums.Effect

func print_data() -> void:
	var thisScript: GDScript = get_script()
	print('Properties of "%s":' % [ thisScript.resource_path ])
	for propertyInfo in thisScript.get_script_property_list():
		var propertyName: String = propertyInfo.name
		var propertyValue = get(propertyName)
		print(' %s = %s' % [ propertyName, propertyValue ])
