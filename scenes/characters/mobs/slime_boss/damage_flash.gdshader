shader_type canvas_item;

uniform float flash_strength = 0.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (flash_strength > 0.0) {
        tex_color.rgb = mix(tex_color.rgb, vec3(1.0), flash_strength);
    }
    COLOR = tex_color;
}
