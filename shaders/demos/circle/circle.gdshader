shader_type spatial;

uniform vec2 circle_center = vec2(0.5,0.5);
uniform float circle_radius = 0.5;

void vertex() {
}

void fragment() {
	float radius = 0.5;
	vec2 point = vec2(0.5,0.5);
	if ( length(UV-point) / radius <= 1.0f ) {
		ALBEDO = vec3(0,0,0);
	} else {
		ALBEDO = vec3(1,1,1);
	}
}
