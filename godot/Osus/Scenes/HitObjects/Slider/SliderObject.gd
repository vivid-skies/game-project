extends Path2D

signal movement_finished

# Slider Path and its children
@onready var slider_path: Line2D = $SliderPath
@onready var growth_timer: Timer = $SliderPath/GrowthTimer

# Slider Follow and its children
@onready var slider_follow: Node = $SliderFollow
@onready var hitbox: Node = $SliderFollow/Hitbox
@onready var hit_circle: Sprite2D = $SliderFollow/Hitbox/HitCircle
@onready var approach_circle: ColorRect = $SliderFollow/Hitbox/ApproachCircle
@onready var score_timer: Timer = $SliderFollow/Hitbox/ScoreTimer
# @onready var animation_player: AnimationPlayer = $AnimationPlayer

# Tweens for animation
@onready var slider_path_tween: Tween
@onready var slider_follow_tween: Tween
@onready var hitbox_tween: Tween


@export var growth_speed: float = 0.00001
@export var expand_width: float = 25
@export var expand_time: float = 0.5


# var pointA: Vector2i = Vector2i(109, 159)
# var	pointB: Vector2i = Vector2i(184, 176)
# var	pointC: Vector2i = Vector2i(223, 243)
# var points_arr: PackedVector2Array = [pointA, pointB, pointC]
var coords: PackedVector2Array

# Slider Path vars
var path_points: PackedVector2Array

# Slider Object vars
var beat_delay: float = 0.5  #beats before roller start
var radius_start: float = 150.0
var radius_end: float = 70.0  #(150 - TargetCircle width) / 2.0
var order_number: int = 0
var lifetime: float
var bps: float

# Hitbox vars
var score: int = 0
var poll_time: float = 0.0
var poll_amount: int = 10
var player_in_bounds: bool = false


func _ready() -> void:

	pass

func initialise(p_curve: Curve2D, duration: float, bps: float, color: Color = Color.ALICE_BLUE) -> void:
	curve.clear_points()
	for point in coords: 
		curve.add_point(point)


	curve = p_curve
	var curve_points: PackedVector2Array = curve.get_baked_points()
	
	setup_slider_path(curve_points)
	start_slider_path()

	setup_hitbox(bps, duration)

	var roller_path_delay: float = bps * beat_delay
	var roller_path_duration: float = bps * duration / 2.0

	start_slider_follow(roller_path_delay, roller_path_duration)
	
	# global_position = data.global_position
	global_position = curve_points[0]
	
	# hit_circle.setup(radius_start, radius_end, data.bps, beat_delay)

func setup_slider_path(points: PackedVector2Array) -> void:
	path_points = points
	slider_path.clear_points()


func start_slider_path() -> void:
	growth_timer.start(growth_speed)
	slider_path_tween = create_tween().bind_node(slider_path)
	slider_path_tween.stop()
	slider_path_tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT_IN)
	slider_path_tween.tween_property(slider_path, "width", expand_width, expand_time).from(0)
	slider_path_tween.play()


func start_slider_follow(delay: float, duration: float) -> void:
	# await(get_tree().create_timer(delay).timeout)
	# start_hitbox()
	slider_follow_tween = create_tween().bind_node(slider_follow)
	slider_follow_tween.stop()
	slider_follow_tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT_IN)
	slider_follow_tween.tween_property(slider_follow, "progress_ratio", 1, duration).from(0)
	slider_follow_tween.play()

	await(slider_follow_tween.loop_finished)
	emit_signal("movement_finished")


func setup_hitbox(beats_per_second: float, duration: float) -> void:
	poll_time = beats_per_second * duration / 2.0 / poll_amount 

func start_hitbox() -> void:
	hitbox_tween = create_tween().bind_node(hitbox)
	hitbox_tween.stop()
	# hitbox_tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT_IN)
	# hitbox_tween.tween_property(sprite, "scale", Vector2.ONE, 0.2).from(Vector2.ZERO)
	hitbox_tween.play()

	score_timer.start(poll_time)


func set_order_number(number: int) -> void:
	order_number = number
	# _label_start.text = str(number)
	# _label_end.text = str(number + 1)

func _on_movement_finished() -> void:
	print("slider dedge")
	queue_free()
	pass # Replace with function body.


func destroy() -> void:
	# _animation_player.play("destroy")
	pass


func _on_growth_timer_timeout() -> void:
	if not path_points: return growth_timer.stop()
	slider_path.add_point(path_points[0])
	path_points.remove_at(0)


func _on_mouse_entered() -> void:
	player_in_bounds = true


func _on_mouse_exited() -> void:
	player_in_bounds = false


func _on_score_timer_timeout() -> void:
	# if not player_in_bounds: return
	# if not Input.is_action_pressed("touch"): return
	# score += 1
	pass
