class_name IBeatmapHitObject


var x: int
var y: int
var time: int
var type: Enums.HitObject
var hit_sound: Enums.HitSound
var hit_sample: IHitSample


# Taiko Stuff
class EdgeSet:
	var normal_set: Enums.HitSample
	var addition_set: Enums.HitSample



# Mania stuff
class Holds extends IBeatmapHitObject:
	pass

func print_data() -> void:
	var thisScript: GDScript = get_script()
	print('Properties of "%s":' % [ thisScript.resource_path ])
	for propertyInfo in thisScript.get_script_property_list():
		var propertyName: String = propertyInfo.name
		var propertyValue = get(propertyName)
		print(' %s = %s' % [ propertyName, propertyValue ])
