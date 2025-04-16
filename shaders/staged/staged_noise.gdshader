shader_type canvas_item;

uniform sampler2D noise;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.rgb = texture(noise,UV).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
