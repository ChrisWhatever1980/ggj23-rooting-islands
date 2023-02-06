shader_type spatial;

uniform vec4 color : hint_color;
uniform float grow;
varying float v_alpha;

void vertex()
{
	if (UV.x > grow)
		v_alpha = 0.0;
	else
		v_alpha = 1.0;
}

void fragment()
{
	ALBEDO = color.rgb;
	ALPHA = v_alpha;
}