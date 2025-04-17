shader_type canvas_item;

uniform float scale = 0.1;
uniform vec2  offset = vec2(0,0);
uniform sampler2D pattern;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV-offset;
	ivec2 tile_position = ivec2(floor(uv/scale));
	vec2 inner_position = (uv - vec2(tile_position)*scale)/scale;
	COLOR = texture(pattern,inner_position);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
