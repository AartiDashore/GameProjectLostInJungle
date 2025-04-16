shader_type canvas_item;

uniform float scale = 0.1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (length((UV-0.5)/2.0)/scale < 1.f){
		COLOR = vec4(0,0,0,1);
	}
}
