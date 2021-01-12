shader_type canvas_item;

uniform float cutoff : hint_range(0.0, 1.0);
uniform float blur : hint_range(0.0, 1.0);
uniform sampler2D mask : hint_albedo;

uniform sampler2D front_texture;
uniform sampler2D back_texture;

void fragment() {
	float value = texture(mask, UV).r;
	float alpha = smoothstep(cutoff, cutoff + blur, value * (1.0 - blur) + blur);
	
	vec4 front_color = texture(front_texture, SCREEN_UV);
	vec4 back_color = texture(back_texture,SCREEN_UV);
		
	COLOR = mix(front_color,back_color,alpha);
}
