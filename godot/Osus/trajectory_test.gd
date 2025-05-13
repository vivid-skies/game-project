extends Node2D


var start_points: Vector2 = Vector2(1, 0)
@export var EXPLOSION_FORCE: float = 200


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	# draw_line(Vector2.ZERO, Vector2(50, -100), Color.SEA_GREEN, 2)
	# var pointA: Vector2 = Vector2(0, 0)
	# var pointB: Vector2 = Vector2(200, 200)
	# draw_line_global(pointA, pointB, Color.RED, 2)
	update_trajectory()
	pass

func get_forward_direction() -> Vector2:
	return global_position.direction_to(get_global_mouse_position())

func draw_line_global(pointA: Vector2, pointB: Vector2, color: Color, width: int = -1) -> void: 
	var local_offset: Vector2 = pointA - global_position
	var pointB_local: Vector2 = pointB - global_position
	
	draw_line(local_offset, pointB_local, color, width)


func update_trajectory() -> void:
	var velocity: Vector2 = EXPLOSION_FORCE * get_forward_direction()
	var line_start: Vector2 = global_position
	var line_end: Vector2
	var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
	var drag: float = ProjectSettings.get_setting("physics/2d/default_linear_damp")
	var timestep: float = 0.02
	var colors: PackedColorArray = [Color.RED, Color.BLUE]
	
	for i in 70:
		line_end = line_start + (velocity * timestep)
		velocity = velocity * clampf(1.0 - drag * timestep, 0, 1)

		var ray: Dictionary = raycast_query2d(line_start, line_end)
		
		# If it hits something
		if not ray.is_empty():
			break

		draw_line_global(line_start, line_end, colors[i%2])
		line_start = line_end
		pass

func raycast_query2d(pointA: Vector2, pointB: Vector2) -> Dictionary:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(pointA, pointB, 1)
	var result: Dictionary = space_state.intersect_ray(query)

	return result
