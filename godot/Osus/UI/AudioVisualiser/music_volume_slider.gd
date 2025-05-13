extends VSlider

@export var bus_name: String
@export var volume_label: Label


var bus_index: int
var bus_volume: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)

	bus_volume = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	value = bus_volume
	volume_label.text = str(int(value * 100)) + "%"

func _on_value_changed(val: float) -> void:
	# print(val)
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(val)
	)
	volume_label.text = str(int(val * 100)) + "%"
