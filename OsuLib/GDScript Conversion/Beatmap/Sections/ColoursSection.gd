class_name IBeatmapColours


var rgb: PackedInt32Array

func print_data() -> void:
	var thisScript: GDScript = get_script()
	print('Properties of "%s":' % [ thisScript.resource_path ])
	for propertyInfo in thisScript.get_script_property_list():
		var propertyName: String = propertyInfo.name
		var propertyValue = get(propertyName)
		print(' %s = %s' % [ propertyName, propertyValue ])
