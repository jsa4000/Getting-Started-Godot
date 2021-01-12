shader_type spatial;
render_mode depth_test_disable, depth_draw_never, unshaded, cull_disabled;

uniform vec4 smooth_zone;
uniform vec4 dead_zone;
uniform vec2 offset;

void vertex() {
  POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
    vec2 uv = UV;
    vec3 chroma;

	vec2 dz_origin = dead_zone.xy + offset.xy;
	vec2 sz_origin = smooth_zone.xy + offset.xy;

	if ((uv.x > sz_origin.x && uv.x < sz_origin.x + smooth_zone.z && uv.y > sz_origin.y && uv.y < sz_origin.y + smooth_zone.a) &&
		!(uv.x > dz_origin.x && uv.x < dz_origin.x + dead_zone.z && uv.y > dz_origin.y && uv.y < dz_origin.y + dead_zone.a))
	{
		chroma = vec3(1.0, 0.0, 0.0);
	} else {
		chroma =  textureLod( SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	}

	ALPHA = 0.5;
	ALBEDO = chroma;
}


