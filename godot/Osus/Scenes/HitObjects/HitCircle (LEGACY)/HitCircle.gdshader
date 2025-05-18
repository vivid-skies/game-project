shader_type canvas_item;

uniform float torus_thickness : hint_range(0.001, 1.0) = 0.015;
uniform float torus_hardness = -2.0;
uniform float torus_radius = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float torus_distance = length((UV - vec2(0.5)) * 1.0);
	float radius_distance = torus_thickness / 2.0;
	float inner_radius = torus_radius - radius_distance;

	float circle_value = clamp(abs(torus_distance - inner_radius) / torus_thickness, 0.0, 1.0);
	float circle_alpha = pow(circle_value, pow(torus_hardness, 2.0));

	float mask = abs(1.0 - circle_alpha);

	COLOR = vec4(mask);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
