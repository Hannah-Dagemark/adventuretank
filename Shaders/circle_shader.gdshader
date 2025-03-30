shader_type canvas_item;

uniform vec4 circle_color = vec4(0.0, 0.5, 1.0, 1.0);
uniform float radius : hint_range(0.0, 1.0) = 0.4;
uniform float border_thickness : hint_range(0.0, 0.2) = 0.05;

void vertex() {
	// Called for every vertex the material is visible on.
}


void fragment() {
    vec2 uv = UV - vec2(0.5);
    float dist = length(uv);

    if (dist < radius) {
        COLOR = circle_color;
    } else if (dist < radius + border_thickness) {
        COLOR = vec4(0, 0, 0, 1);
    } else {
        discard;
    }
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
