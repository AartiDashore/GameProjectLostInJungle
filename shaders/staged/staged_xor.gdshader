shader_type canvas_item;

uniform sampler2D texture_a;
uniform sampler2D texture_b;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 color_a = texture(texture_a,UV).rgb;
	vec3 color_b = texture(texture_b,UV).rgb;
	COLOR.rgb = vec3(1,1,1) - abs(color_a-color_b);
}

