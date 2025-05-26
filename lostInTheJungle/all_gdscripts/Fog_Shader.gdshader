shader_type spatial;
render_mode unshaded, blend_mix;

uniform vec4 fog_color : source_color = vec4(0.1, 0.2, 0.3, 1.0); // Fog color
uniform float fog_start = 10.0;   // Distance at which fog begins
uniform float fog_end = 50.0;     // Distance at which fog fully obscures

uniform vec3 camera_position;     // Must be passed from GDScript

void fragment() {
    // Get world-space position of this pixel
    vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    
    // Distance from camera to this pixel
    float dist = distance(world_pos, camera_position);

    // Calculate fog factor based on distance
    float fog_factor = clamp((dist - fog_start) / (fog_end - fog_start), 0.0, 1.0);

    // Base color (can be changed or use texture sample)
    vec3 base_color = vec3(1.0); // White by default

    // Blend base color with fog
    vec3 final_color = mix(base_color, fog_color.rgb, fog_factor);

    ALBEDO = final_color;
    ALPHA = 1.0; // Set to < 1.0 if using partial transparency
}
