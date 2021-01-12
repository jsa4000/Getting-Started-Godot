shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx,unshaded;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float proximity_fade_distance;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform float speed : hint_range(-1,1) = 0.01;
uniform float contrast : hint_range(0,50) = 3;
uniform sampler2D noise;
uniform vec2 direction = vec2(0.0, 1.0);	

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() {
	vec2 time = TIME * speed * direction;
	vec3 noise_tex = texture(noise, UV + time).rgb;
  	noise_tex = ((noise_tex - 0.5f) * max(contrast, 0)) + 0.5f;
	
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	
	float depth_tex = textureLod(DEPTH_TEXTURE,SCREEN_UV,0.0).r;
	vec4 world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV*2.0-1.0,depth_tex*2.0-1.0,1.0);
	world_pos.xyz/=world_pos.w;
	
	ALPHA = albedo.a * albedo_tex.a;
	ALPHA *= clamp(noise_tex.r,0.0,1.0);
	ALPHA *= clamp(1.0-(distance(vec2(0.5,1.0), UV) * 2.0),0.0,1.0);
	ALPHA*=clamp(1.0-smoothstep(world_pos.z+proximity_fade_distance,world_pos.z,VERTEX.z),0.0,1.0);
}
