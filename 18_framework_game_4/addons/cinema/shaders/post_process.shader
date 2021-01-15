shader_type canvas_item;

uniform float light : hint_range(0, 1) = 0.2;
uniform float extend : hint_range(0, 1) = 0.5;
uniform float offset : hint_range(0, 10) = 3.0;

uniform float grain : hint_range(0, 1) = 0.1;
uniform float grain_brightness : hint_range(0, 1) = 0.5;
uniform float grain_contrast : hint_range(0, 100) = 3.0;

uniform float sharpness : hint_range(0, 32) = 1.0;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

//Screen
vec3 screen (vec3 target, vec3 blend){
	return 1.0 - (1.0 - target) * (1.0 - blend);
}

//Overlay
vec3 overlay (vec3 target, vec3 blend){
	vec3 temp;
	temp.x = (target.x > 0.5) ? (1.0-(1.0-2.0*(target.x-0.5))*(1.0-blend.x)) : (2.0*target.x)*blend.x;
	temp.y = (target.y > 0.5) ? (1.0-(1.0-2.0*(target.y-0.5))*(1.0-blend.y)) : (2.0*target.y)*blend.y;
	temp.z = (target.z > 0.5) ? (1.0-(1.0-2.0*(target.z-0.5))*(1.0-blend.z)) : (2.0*target.z)*blend.z;
	return temp;
}

// Shapen
vec4 sharpen(sampler2D tex, vec2 fragCoord, vec2 resolution, float strength)
{
    vec4 up = texture (tex, (fragCoord + vec2 (0, 1))/resolution);
    vec4 left = texture (tex, (fragCoord + vec2 (-1, 0))/resolution);
    vec4 center = texture (tex, fragCoord/resolution);
    vec4 right = texture (tex, (fragCoord + vec2 (1, 0))/resolution);
    vec4 down = texture (tex, (fragCoord + vec2 (0, -1))/resolution);
    
    return (4.0 * strength) * center - strength * (up + left + right + down);
}

//Grayscale
float grayscale (vec3 color){
	return dot(color.rgb, vec3(0.299, 0.587, 0.114));
}

vec3 contrast(vec3 color, float contrast) {
	return ((color - 0.5f) * max(contrast, 0)) + 0.5f;
}

void fragment() {
    vec2 uv = UV;
    vec3 chroma;
    float amount = offset * 0.0005;

    // cache screen
    vec3 og_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;

    // cache screen witch chroma (r/b shifted by ammount)
    chroma.r = textureLod(SCREEN_TEXTURE, SCREEN_UV + vec2(amount, 0.), 0.0).r;
    chroma.g = og_color.g;
    chroma.b = textureLod(SCREEN_TEXTURE, SCREEN_UV - vec2(amount, 0.), 0.0).b;
    
    // generate gradient from center to the corners
    uv *=  1.0 - uv.yx;
    float vig = uv.x*uv.y * 15.;
    vig = pow(vig, extend);
    vig = 1.0 - vig;

    // mix chroma with original image by the gradient (more on corners, less in center)
    chroma = mix(og_color, chroma, vig * 2.);
    
	if (grain > 0.0001) {
		vec3 bw = contrast(vec3(grayscale(chroma)), grain_contrast) + grain_brightness;
		chroma = mix(chroma, vec3(rand(UV)), (1.0 - clamp(bw.r,0.0,1.0)) * grain);
	}
	
	if (sharpness > 0.0001) {
		vec4 mask = sharpen(SCREEN_TEXTURE, FRAGCOORD.xy, 1.0 / SCREEN_PIXEL_SIZE, sharpness);
		chroma = screen(chroma, mask.rgb);
	}
	
	// mix chroma with vignette (darker version of chroma image)
	COLOR = vec4(mix(chroma, chroma * vec3(light), vig), 1.0);
	
}