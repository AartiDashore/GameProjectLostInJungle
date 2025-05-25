//shader_type spatial;
//render_mode unshaded;
//uniform sampler2D dirt_texture;
//uniform sampler2D noise_tex;
//
//void vertex() {
	//// Called for every vertex the material is visible on.bool
//}
//
//float noise(vec2 uv) {
    //return fract(sin(dot(uv, vec2(12.9898,78.233))) * 43758.5453);
//}
//
//void fragment() {
	//// Called for every pixel the material is visible on.
	//vec3 brown_ground = vec3(0.486, 0.282, 0.027);
	//vec3 dirt_texture_color = texture(dirt_texture, UV).rgb;
    ////ALBEDO = mix(brown_ground, dirt_texture_color, 0.1);
	////float dirt_noise = noise(UV * 5.0);
	//float dirt_noise = texture(noise_tex, UV * 2.0).r;
	//dirt_noise = smoothstep(0.3, 0.7, dirt_noise);  // Smooth noise value
//
    //// Mix ground color and noise
    //vec3 blended = mix(brown_ground, vec3(dirt_noise), 0.2);
    //ALBEDO = clamp(blended, 0.0, 1.0);  // Safe range
//}
//
////void light() {
////	// Called for every pixel for every light affecting the material.
////	// Uncomment to replace the default light processing function with this one.
////}
//shader_type spatial;
//render_mode unshaded;
//
//void fragment() {
    //float noise = fract(sin(dot(UV, vec2(12.9898,78.233))) * 43758.5453);
    //float brightness = mix(0.9, 1.1, noise); // slight variation
//
    //vec3 base_color = vec3(0.176, 0.122, 0.059); // dark soil
    //ALBEDO = base_color * brightness;
//}
shader_type spatial;
render_mode unshaded;

uniform sampler2D noise_tex;

void fragment() {
    vec3 base_black = vec3(0.01, 0.01, 0.01);       // Nearly pure black soil
    vec3 dark_patch = vec3(0.05, 0.05, 0.05);       // Very dark gray rough patches
    vec3 moss_teal = vec3(0.02, 0.04, 0.03);        // Dark muted teal-green moss

    float noise_val = texture(noise_tex, UV * 3.0).r;

    // Rough patch mask: subtle dark gray patches
    float rough_mask = smoothstep(0.4, 0.6, noise_val);

    // Moss patch mask: different threshold for scattered moss spots
    float moss_mask = smoothstep(0.65, 0.85, noise_val);

    // Mix base black with rough patches
    vec3 color = mix(base_black, dark_patch, rough_mask);

    // Add moss patches on top
    color = mix(color, moss_teal, moss_mask);

    ALBEDO = color;
}


