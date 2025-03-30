shader_type canvas_item;

float cross2d(vec2 v1, vec2 v2) {
    return v1.x * v2.y - v1.y * v2.x;
}

void fragment() {
    vec2 p = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
    vec2 center = vec2(0.5, 0.5);
    float size = 0.4;

    vec2 v1 = center + vec2(-size, -size);
    vec2 v2 = center + vec2(size, -size);
    vec2 v3 = center + vec2(0.0, size);

    float area = cross2d(v2 - v1, v3 - v1);
    float w1 = cross2d(p - v2, v3 - v2) / area;
    float w2 = cross2d(p - v3, v1 - v3) / area;
    float w3 = 1.0 - w1 - w2;

    if (w1 >= 0.0 && w2 >= 0.0 && w3 >= 0.0) {
        COLOR = vec4(1.0, 0.0, 0.0, 1.0);
    } else {
        discard;
    }
}
