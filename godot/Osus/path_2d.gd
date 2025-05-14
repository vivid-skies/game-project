@tool
extends Path2D

@onready var line: Line2D = $Line
@onready var HitCircle: TextureRect = $HitCircle

var time: float = 0.0

var pointA: Vector2i = Vector2i(109, 159)
var	pointB: Vector2i = Vector2i(184, 176)
var	pointC: Vector2i = Vector2i(223, 243)
var points_arr: PackedVector2Array = [pointA, pointB, pointC]

var disable_loop: bool = true
var reverse: bool = false

var hit_circle_points: PackedVector2Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# print(calculate_path().size())
	# line.points = calculate_path()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var point: Vector2 = draw_quadractic_bezier(pointA, pointB, pointC, time)

	# This is just for debugging purposes

	if time >= 1 and disable_loop:
		set_process(false)
		print("Line Points")
		print(line.points)
		print("\n\n\n")
		print("Hit Circle Points")
		print(hit_circle_points)
		return

	if time >= 1 and not reverse: reverse = true
	elif time <= 0 and reverse: reverse = false

	if reverse: time -= delta
	if not reverse: time += delta

	# This is to draw the slider behind the hitobject
	hit_circle_points.append(point)
	line.add_point(point)
	HitCircle.position = point

func _draw() -> void:
	# draw_bezier()
	pass

func calculate_path(duration: float) -> void:
	# Insead of processing the curves in real time using physics,
	# Think I can pre-calculate the points before runtime and use those instead maybe? Idk
	# const MAX_DURATION: float = 1.0
	# var duration: float = 0.0
	# var points: PackedVector2Array
	# while duration <= MAX_DURATION:
	# 	var point: Vector2 = draw_quadractic_bezier(pointA, pointB, pointC, time)
	# 	points.append(point)
	# 	duration += 0.05
	var point: Vector2 = draw_quadractic_bezier(pointA, pointB, pointC, duration)
	line.add_point(point)
	# return points

func draw_quadractic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var q0: Vector2 = p0.lerp(p1, t)
	var q1: Vector2 = p1.lerp(p2, t)

	var r: Vector2 = q0.lerp(q1, t)

	return r

func draw_cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float) -> Vector2:
	var q0: Vector2 = p0.lerp(p1, t)
	var q1: Vector2 = p1.lerp(p2, t)
	var q2: Vector2 = p2.lerp(p3, t)

	var r0: Vector2 = q0.lerp(q1, t)
	var r1: Vector2 = q1.lerp(q2, t)
	
	var s: Vector2 = r0.lerp(r1, t)
	return s

func draw_linear_curve() -> Vector2:


	return Vector2(0, 0)


func loop_slider(repeats: int) -> void:
	


	pass


func draw_bezier() -> void:
	# var mousePos: Vector2 = get_global_mouse_position() - self.position
	# self.curve.set_point_position(0, Vector2(0,0))
	# curve.set_point_position(0, Vector2(0, 0))
	for point in points_arr: 
		self.curve.add_point(point)

	self.curve.tessellate(5)
