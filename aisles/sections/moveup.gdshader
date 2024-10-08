shader_type canvas_item;


uniform float scroll_speed = 0.1; // Speed of scrolling

void fragment() {
    vec2 uv = UV;
    uv.y += TIME * scroll_speed;
    uv.y = fract(uv.y); // Wrap the x coordinate for infinite scrolling
    COLOR = texture(TEXTURE, uv);
}






//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
