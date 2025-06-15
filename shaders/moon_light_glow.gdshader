shader_type spatial;
render_mode unshaded;

uniform vec4 moon_color = vec4(0.6, 0.6, 1.0, 1.0);
uniform float glow_strength = 1111.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float dist = length(UV - vec2(0.5));
    float glow = smoothstep(0.5, 0.0, dist);

    ALBEDO = moon_color.rgb * glow * glow_strength;
    ALPHA = glow; // This creates the fade-out to transparent edges

}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
