shader_type canvas_item;

uniform float scanline_strength : hint_range(0.0, 1.0) = 0.16;
uniform float flicker_strength : hint_range(0.0, 1.0) = 0.03;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.28;

void fragment() {
	vec2 uv = UV;

	float scan = sin(uv.y * 900.0) * 0.5 + 0.5;
	scan = 1.0 - scan * scanline_strength;

	float dist = distance(uv, vec2(0.5, 0.5));
	float vignette = smoothstep(0.85, 0.25, dist);
	vignette = mix(1.0 - vignette_strength, 1.0, vignette);

	float flicker = 1.0 + sin(TIME * 40.0) * flicker_strength;

	vec3 tint = vec3(0.0, 0.85, 1.0) * 0.06;

	COLOR = vec4(tint * scan * vignette * flicker, 0.18);
}