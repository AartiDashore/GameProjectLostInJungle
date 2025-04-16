shader_type spatial;
#include "res://shaders/util/step_by_step.gdshaderinc"

varying vec3 world_vertex;

uniform float scale = 1.0;

bool trues_even(bvec3 val) {
	return (int(val.x)+int(val.y)+int(val.z)) % 2 == 0;
}

void vertex() {
	world_vertex = (MODEL_MATRIX * vec4(VERTEX,1)).xyz / scale;
}

void fragment() {
	bvec3 is_positive = greaterThanEqual(world_vertex,vec3(0,0,0));
	ALBEDO = step_3d(vec3(1,1,1),vec3(is_positive),1);
	vec3 rounded_coordinate = floor(world_vertex+0.0001);
	ivec3 inner_coordinate = ivec3(world_vertex - rounded_coordinate);
	ivec3 tile_coordinate = ivec3(rounded_coordinate);
	bvec3 is_even = equal(tile_coordinate % 2,ivec3(0,0,0));
	ALBEDO = step_3d(ALBEDO,vec3(is_even),2);
	bool is_black = trues_even(is_even);
	if (is_black) {
		ALBEDO = step_3d(ALBEDO,vec3(0,0,0),3);
	} else {
		ALBEDO = step_3d(ALBEDO,vec3(1,1,1),3);
	}
}
