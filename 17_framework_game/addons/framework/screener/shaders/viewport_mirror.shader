shader_type spatial;
render_mode unshaded;

const float PI = 3.141592653589793238462643383;

uniform bool mirror = true;
uniform sampler2D reflection_texture;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float cosa = cos(rotation);
    float sina = sin(rotation);
    uv -= pivot;
    return vec2(
        cosa * uv.x - sina * uv.y,
        cosa * uv.y + sina * uv.x 
    ) + pivot;
}

void fragment() {
	vec2 uv_rotated = rotateUV(UV, vec2(0.5), PI);
	if (mirror)
		ALBEDO = texture(reflection_texture, vec2(1.0 - uv_rotated.x, uv_rotated.y)).rgb;
	else
		ALBEDO = texture(reflection_texture, uv_rotated).rgb;
}