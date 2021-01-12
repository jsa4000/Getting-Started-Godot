shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx;

uniform sampler2D u_terrain_heightmap;
uniform sampler2D u_terrain_detailmap;
uniform sampler2D u_terrain_normalmap;
uniform sampler2D u_terrain_globalmap : hint_albedo;
uniform mat4 u_terrain_inverse_transform;
uniform mat3 u_terrain_normal_basis;

uniform sampler2D u_albedo_alpha : hint_albedo;
uniform float u_view_distance = 100.0;
uniform float u_globalmap_tint_bottom : hint_range(0.0, 1.0);
uniform float u_globalmap_tint_top : hint_range(0.0, 1.0);
uniform float u_bottom_ao : hint_range(0.0, 1.0);
uniform vec2 u_ambient_wind; // x: amplitude, y: time
uniform vec3 u_instance_scale = vec3(1.0, 1.0, 1.0);

// New variabales extracted from SpatialShader
uniform vec4 albedo : hint_color = vec4(1.0);
uniform float specular : hint_range(0,1) = 0.5;
uniform float metallic : hint_range(0,1);
uniform float alpha_scissor_threshold : hint_range(0,1) = 0.3;
uniform float roughness : hint_range(0,1) = 1.0;
uniform float point_size : hint_range(0,128);
uniform sampler2D texture_metallic : hint_white;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_white;
uniform vec4 roughness_texture_channel;
uniform sampler2D texture_normal : hint_normal;
uniform float normal_scale : hint_range(-16,16);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

varying vec3 v_normal;
varying vec2 v_map_uv;

float get_hash(vec2 c) {
	return fract(sin(dot(c.xy, vec2(12.9898,78.233))) * 43758.5453);
}

vec3 unpack_normal(vec4 rgba) {
	vec3 n = rgba.xzy * 2.0 - vec3(1.0);
	n.z *= -1.0;
	return n;
}

vec3 get_ambient_wind_displacement(vec2 uv, float hash) {
	// TODO This is an initial basic implementation. It may be improved in the future, especially for strong wind.
	float t = u_ambient_wind.y;
	float amp = u_ambient_wind.x * (1.0 - uv.y);
	// Main displacement
	vec3 disp = amp * vec3(cos(t), 0, sin(t * 1.2));
	// Fine displacement
	float fine_disp_frequency = 2.0;
	disp += 0.2 * amp * vec3(cos(t * (fine_disp_frequency + hash)), 0, sin(t * (fine_disp_frequency + hash) * 1.2));
	return disp;
}

void vertex() {
	vec4 obj_pos = WORLD_MATRIX * vec4(0, 1, 0, 1);
	vec3 cell_coords = (u_terrain_inverse_transform * obj_pos).xyz;
	// Must add a half-offset so that we sample the center of pixels,
	// otherwise bilinear filtering of the textures will give us mixed results (#183)
	cell_coords.xz += vec2(0.5);
	
	vec2 map_uv = cell_coords.xz / vec2(textureSize(u_terrain_heightmap, 0));
	v_map_uv = map_uv;

	//float density = 0.5 + 0.5 * sin(4.0*TIME); // test
	float density = texture(u_terrain_detailmap, map_uv).r;
	float hash = get_hash(obj_pos.xz);
	
	if (density > hash) {
		// Snap model to the terrain
		float height = texture(u_terrain_heightmap, map_uv).r / cell_coords.y;
		VERTEX *= u_instance_scale;
		VERTEX.y += height;
		
		VERTEX += get_ambient_wind_displacement(UV, hash);
		
		// Fade alpha with distance
		vec3 wpos = (WORLD_MATRIX * vec4(VERTEX, 1)).xyz;
		float dr = distance(wpos, CAMERA_MATRIX[3].xyz) / u_view_distance;
		COLOR.a = clamp(1.0 - dr * dr * dr, 0.0, 1.0);

		// When using billboards, the normal is the same as the terrain regardless of face orientation
		v_normal = normalize(u_terrain_normal_basis * unpack_normal(texture(u_terrain_normalmap, map_uv)));

	} else {
		// Discard, output degenerate triangles
		VERTEX = vec3(0, 0, 0);
	}
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(u_albedo_alpha,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	
	// Blend with ground color
	float nh = sqrt(1.0 - UV.y);
	ALBEDO = mix(ALBEDO, texture(u_terrain_globalmap, v_map_uv).rgb, mix(u_globalmap_tint_bottom, u_globalmap_tint_top, nh));
	
	// Fake bottom AO
	ALBEDO = ALBEDO * mix(1.0, 1.0 - u_bottom_ao, UV.y * UV.y);
	
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	NORMALMAP = texture(texture_normal,base_uv).rgb;
	NORMALMAP_DEPTH = normal_scale;
	ALPHA = albedo.a * albedo_tex.a;
	ALPHA_SCISSOR=alpha_scissor_threshold;
}
