extends Node2D


func _draw() -> void:
	draw_arc(Vector2.ZERO, 100, deg_to_rad(20), deg_to_rad(360 - 20), 50, Color.YELLOW, 200)
	pass
