shader_type spatial;
render_mode unshaded;
uniform sampler2D dirt_texture;

void vertex() {
	// Called for every vertex the material is visible on.bool
}

float noise(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 brown_ground = vec3(0.5, 0.3, 0.1);
	vec3 dirt_texture_color = texture(dirt_texture, UV).rgb; 
    //ALBEDO = mix(brown_ground, dirt_texture_color, 0.1);
	float dirt_noise = noise(UV * 5.0); 
    ALBEDO = mix(brown_ground, vec3(dirt_noise), 0.2);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
