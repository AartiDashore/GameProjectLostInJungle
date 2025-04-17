shader_type spatial;

#include "res://shaders/util/step_by_step.gdshaderinc"

uniform vec2 circle_center = vec2(0.5,0.5);
uniform float circle_radius = 0.5;

void vertex() {

}

void fragment() {
	ALBEDO.rg = UV.xy;
	vec2 offset = UV - circle_center;
	ALBEDO = step_3d(ALBEDO,vec3(offset.xy,0),1);
	float offset_length = length(offset);
	ALBEDO = step_3d(ALBEDO,vec3(offset_length),2);
	if (length(offset) < circle_radius) {
		ALBEDO = step_3d(ALBEDO,vec3(0,0,0),3);
	} else {
		ALBEDO = step_3d(ALBEDO,vec3(1,1,1),3);
	}
}
