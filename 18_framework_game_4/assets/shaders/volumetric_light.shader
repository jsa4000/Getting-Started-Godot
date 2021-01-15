shader_type spatial;
render_mode blend_add,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,shadows_disabled;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo,filter_linear_mipmap,repeat_enable;
uniform float proximity_fade_distance;
uniform float distance_fade_min;
uniform float distance_fade_max;
uniform float point_size : hint_range(0,128);
uniform float roughness : hint_range(0,1);
uniform sampler2D texture_metallic : hint_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular;
uniform float metallic;
uniform sampler2D texture_emission : hint_black_albedo,filter_linear_mipmap,repeat_enable;
uniform vec4 emission : hint_color;
uniform float emission_energy;
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
	vec3 noise_tex = texture(noise, SCREEN_UV + time).rgb;
  	noise_tex = ((noise_tex - 0.5f) * max(contrast, 0)) + 0.5f;
	
	vec2 base_uv = UV;
	//float fresnel = sqrt(1.0-dot(NORMAL,VIEW));
	float fresnel = sqrt(dot(NORMAL,VIEW));
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	albedo_tex *= COLOR;
	ALBEDO = (albedo.rgb * albedo_tex.rgb) + (0.1 * fresnel);
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	
	vec3 emission_tex = texture(texture_emission,base_uv).rgb;
	EMISSION = (emission.rgb+emission_tex)*emission_energy;

	float depth_tex = textureLod(DEPTH_TEXTURE,SCREEN_UV,0.0).r;
	vec4 world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV*2.0-1.0,depth_tex*2.0-1.0,1.0);
	world_pos.xyz/=world_pos.w;
	
	ALPHA = clamp((albedo.a * albedo_tex.a) + (0.005 * fresnel),0.0,1.0);
	ALPHA *= clamp(noise_tex.r,0.0,1.0);
	ALPHA *= clamp(1.0-(distance(vec2(0.5,0.5), UV) * 2.0),0.0,1.0);
	ALPHA*=clamp(1.0-smoothstep(world_pos.z+proximity_fade_distance,world_pos.z,VERTEX.z),0.0,1.0);
	ALPHA*=clamp(smoothstep(distance_fade_min,distance_fade_max,-VERTEX.z),0.0,1.0);
}
