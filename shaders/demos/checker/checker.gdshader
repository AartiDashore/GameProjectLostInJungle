shader_type spatial;

varying vec3 world_vertex;

uniform vec2  offset = vec2(0,0);
uniform float scale = 1.0;

bool trues_even(bvec3 val) {
	return (int(val.x)+int(val.y)+int(val.z)) % 2 == 0;
}

void vertex() {
	world_vertex = (MODEL_MATRIX * vec4(VERTEX,1)).xyz;
}

vec3 checker(vec3 position) {
	bvec3 is_positive = greaterThanEqual(position,vec3(0,0,0));
	vec3  rounded_coordinate = floor(position+0.0001);
	ivec3 inner_coordinate = ivec3(position - rounded_coordinate);
	ivec3 tile_coordinate = ivec3(rounded_coordinate);
	bvec3 is_even = equal(tile_coordinate % 2,ivec3(0,0,0));
	bool is_black = trues_even(is_even);
	if (is_black) {
		return vec3(0,0,0);
	} else {
		return vec3(1,1,1);
	}
}

vec3 circle(vec3 position) {
	if (length(position) <= 1.f) {
		return vec3(0,0,0);
	} else {
		return vec3(1,1,1);
	}
}

void fragment() {
	vec3 sample_pos = world_vertex;
	sample_pos /= scale;
	sample_pos = sample_pos - floor(sample_pos);
	sample_pos *= 2.0;
	sample_pos -= 0.75;
	ALBEDO = circle(sample_pos);
}
