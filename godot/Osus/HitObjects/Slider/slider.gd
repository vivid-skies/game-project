extends Node2D


# @onready var hit_box: Area2D = $HitBox


var beatmap_info: Dictionary = { 
	dir = "res://bin/processed/482090 9mm Parabellum Bullet - Inferno", 
	file_name = "9mm Parabellum Bullet - Inferno (Monstrata) [Agonizing Insane]" 
	}

var beatmap_to_parse: String = beatmap_info["dir"] + "/" + beatmap_info["file_name"] + ".osu"

var beatmap: Beatmap
var beatmap_dir: String



func _ready() -> void:
	# start_timing_section(4)
	# start_timer()
	pass

func _process(delta: float) -> void:
	# time += delta
	# position = bezier(pointA, pointB, pointC, time)
	# queue_redraw()
	pass

func _draw() -> void:

	pass


func bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float = 1) -> Vector2:
	p0 = Vector2i(109, 159)
	p1 = Vector2i(184, 176)
	p2 = Vector2i(223, 243)

	var q0: Vector2 = p0.lerp(p1, t)
	var q1: Vector2 = p1.lerp(p2, t)
	
	var r: Vector2 = q0.lerp(q1, t)
	return r

func create_perfect_circle(hit_objects: Array) -> void:
	var curve: Curve2D = Curve2D.new()
	# for i in hit_objects.size():
	# 	print(hit_objects[i])

	# Perfect circle should have three points
	# Otherwise it is a bezel curve
	# pointA = (109, 159)
	# pointB = (184, 176)
	# pointC = (223, 243)
	var hit_object: Variant = hit_objects[0]
	var pointA: Vector2i = hit_object.coord
	var pointB: Vector2i = hit_object.curve_points[0]
	var pointC: Vector2i = hit_object.curve_points[1]

	var line: Line2D = Line2D.new()
	line.antialiased = true
	line.closed = true
	line.default_color = Color.ALICE_BLUE
	line.round_precision = 32
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	
	var points: PackedVector2Array = [pointA, pointB, pointC]
	for point in points:
		curve.add_point(point, Vector2.ONE * 100)

		

	line.points = [pointA, pointB, pointC]



	pass

func draw_line_global(pointA: Vector2, pointB: Vector2, color: Color, width: int = -1) -> void: 
	var local_offset: Vector2 = pointA - global_position
	var pointB_local: Vector2 = pointB - global_position
	
	draw_line(local_offset, pointB_local, color, width)


func _on_hit_box_mouse_action() -> void:
	print("clicked")
	queue_free()

func _on_hit_box_keyboard_action() -> void:
	print("tapped")
	queue_free()


func _on_timing_section_end() -> void:
	print("im dead")
	# queue_free()
	pass





# func start_timing_section (lifetime: float) -> void:
# 	# Sets the duration of the animation aka lifetime
# 	# The death animation and stuff is all handled in the AnimPlayer node 
# 	timing_section_anim.length = lifetime
# 	timing_section_anim.track_set_key_time(0, 1, lifetime)
# 	timing_section_anim.track_set_key_time(1, 0, lifetime)

# 	# Sets the radius of the keys in the track
# 	timing_section_anim.track_set_key_value(0, 0, start_radius)
# 	timing_section_anim.track_set_key_value(0, 1, end_radius)


# 	anim_player.play(TIMING_SECTION)

# func start_timer() -> void:
# 	timer.set("wait_time", 1)
# 	timer.start()
# 	print("Timer started")

# func _on_timer_timeout() -> void:
# 	current_radius = torus.material.get(TORUS_RADIUS)
# 	print("%.2f" % current_radius)
