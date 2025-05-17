extends Node


signal TimingPointStart
@export var timing_point_queue: PackedFloat32Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass

func set_timer() -> void:
	
	pass

func _self_destruct() -> void:
	queue_free()
