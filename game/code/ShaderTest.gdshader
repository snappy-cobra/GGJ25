shader_type canvas_item;
#define RGB(A,B,C) vec3(A.0/255.0, B.0/255.0, C.0/255.0)

// https://thebookofshaders.com/11/
// 2D Random
float random (in vec2 st) {
    return fract(sin(dot(st.xy,
    vec2(12.9898,78.233)))
    * 43758.5453123);
}

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    //     u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
    (c - a)* u.y * (1.0 - u.x) +
    (d - b) * u.x * u.y;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

const int SIZE = 8;
const vec3 LOOKUP[SIZE] = {
	RGB(92,120,80),
	RGB(56,132,102),
	RGB(34,105,98),
	RGB(18,48,100),
	RGB(13,1,73),
	RGB(67,3,83),
	RGB(115,41,43),
	RGB(127,106,28)
};

void fragment() {
	float time = TIME * 0.05;
	
	float diagonal = UV.x - time  - UV.y;
	float index = diagonal * 3.0f;
	
	index += noise(UV * 2.0 + vec2(time * 0.2));
	
	vec3 color_a = LOOKUP[int(mod(index, float(SIZE)))];
	vec3 color_b = LOOKUP[int(mod((index + 1.0), float(SIZE)))];
	
	float mixing_value = fract(index);
	COLOR = vec4(mix(color_a, color_b, mixing_value), 1);	
}
