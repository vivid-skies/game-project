@tool
extends Node2D

const TORUS_THICKNESS: String = "shader_parameter/torus_thickness"
const TORUS_HARDNESS: String = "shader_parameter/torus_hardness"
const TORUS_RADIUS: String = "shader_parameter/torus_radius"
const TIMING_SECTION: String = "timing_section"

@export var start_radius: float = 0.45
@export var end_radius: float = 0.11
@export var disabled: bool = false

# @onready var hit_box: Area2D = $HitBox
@onready var timer: Timer = $Timer
@onready var hit_circle: TextureRect = $Drawables/HitCircle
@onready var torus: ColorRect = $Drawables/Torus
@onready var anim_player: AnimationPlayer = $AnimPlayer

@onready var current_radius: float = torus.material.get(TORUS_RADIUS)
@onready var timing_section_anim: Animation = anim_player.get_animation(TIMING_SECTION)



func _ready() -> void:
	# start_timing_section(4)
	# start_timer()

	pass


func _physics_process(_delta: float) -> void:
	# if Input.is_action_pressed("tap"):
	# 	# print("tap")
		pass


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

func start_timing_section (lifetime: float) -> void:
	# Sets the duration of the animation aka lifetime
	# The death animation and stuff is all handled in the AnimPlayer node 
	timing_section_anim.length = lifetime
	timing_section_anim.track_set_key_time(0, 1, lifetime)
	timing_section_anim.track_set_key_time(1, 0, lifetime)

	# Sets the radius of the keys in the track
	timing_section_anim.track_set_key_value(0, 0, start_radius)
	timing_section_anim.track_set_key_value(0, 1, end_radius)


	anim_player.play(TIMING_SECTION)

func start_timer() -> void:
	timer.set("wait_time", 1)
	timer.start()
	print("Timer started")

func _on_timer_timeout() -> void:
	current_radius = torus.material.get(TORUS_RADIUS)
	print("%.2f" % current_radius)
