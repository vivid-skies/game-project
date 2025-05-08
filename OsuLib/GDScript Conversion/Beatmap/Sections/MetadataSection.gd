class_name IBeatmapMetadata


var title: String
var title_unicode: String
var artist: String
var artist_unicode: String
var creator: String
var version: String
var source: String
var tags: PackedStringArray
var beatmap_id: int
var beatmap_set_id: int

func print_data() -> void:
	var thisScript: GDScript = get_script()
	print('Properties of "%s":' % [ thisScript.resource_path ])
	for propertyInfo in thisScript.get_script_property_list():
		var propertyName: String = propertyInfo.name
		var propertyValue = get(propertyName)
		print(' %s = %s' % [ propertyName, propertyValue ])
