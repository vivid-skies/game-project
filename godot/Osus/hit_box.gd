extends Area2D

signal mouse_action
signal keyboard_action

@onready var collider: CollisionShape2D = $Collider

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			emit_signal("mouse_action")
			return

	if event.is_action(&"tap") and event.is_action_pressed(&"tap"):
		emit_signal("keyboard_action")
		return
	if event.is_action(&"alternate_tap") and event.is_action_pressed(&"alternate_tap"):
		emit_signal("keyboard_action")
		return
