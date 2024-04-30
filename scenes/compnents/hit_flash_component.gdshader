shader_type canvas_item; //2d items

uniform float lerp_percent : hint_range(0.0, 1.0);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 final_color = mix(texture_color, vec4(1.0, 1.0, 1.0, texture_color.a), lerp_percent);
	COLOR = final_color;
}