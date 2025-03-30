shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    if (UV.x > 0.2 && UV.x < 0.8 && UV.y > 0.1 && UV.y < 0.8) {
        COLOR = vec4(0.5, 0.5, 0.5, 1.0); // Gray rectangle
    } else {
        discard; // Transparent outside
    }
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
