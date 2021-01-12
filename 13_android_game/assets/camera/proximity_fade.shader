shader_type spatial;
//render_mode depth_test_disable, depth_draw_never, unshaded, cull_disabled;
//render_mode depth_test_disable, depth_draw_never, unshaded, cull_disabled;

uniform float proximity_fade_distance = 5.0;

void fragment () {
	ALBEDO = vec3(0, 1, 0);
//	float depth_tex = textureLod(DEPTH_TEXTURE,SCREEN_UV,0.0).r;
	float depth_tex = texture(DEPTH_TEXTURE, SCREEN_UV).r;
	vec4 world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV*2.0-1.0,depth_tex*2.0-1.0,1.0);
	world_pos.xyz/=world_pos.w;

	// This is the magical part, I have used a value of 0.001 so it's a tiny clipping margin.
	float depth_clip = clamp(1.0-smoothstep(world_pos.z+0.001,world_pos.z,VERTEX.z),0.0,1.0);
	ALPHA *= depth_clip;

	// Do what ever you want with your depth (like proximity fade in this case)
	float depth = clamp(1.0-smoothstep(world_pos.z+proximity_fade_distance,world_pos.z,VERTEX.z),0.0,1.0);
	ALBEDO = vec3(depth);
}