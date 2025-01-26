shader_type canvas_item;

varying float roffset;

void vertex() {
	roffset = float(INSTANCE_ID) * 18.1324;
	//roffset = 0.0;//(VERTEX.x + 5.0 * VERTEX.y)/ 100.0;
}

void fragment() {
	float m = length(UV - vec2(0.5, 0.5));
	if (m > 0.5) {
		discard;
	} else {
		COLOR.a = clamp((sin(TIME*3.0 - m + roffset)-0.9)*3.0, 0.0, 1.0);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
