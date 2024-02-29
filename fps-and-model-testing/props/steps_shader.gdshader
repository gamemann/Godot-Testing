shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx,unshaded;
uniform vec4 albedo : source_color = vec4(1.0, 1.0, 1.0, 0.0);


uniform float specular;


varying flat vec3 norm;
varying flat float norm_val;

uniform float offset = 0.05;

uniform float opacity = 0.9;


uniform sampler2D SCREEN_TEXTURE: hint_screen_texture,filter_linear_mipmap;

void vertex() {
	norm = NORMAL;
}










void fragment() {
	
	
	vec3 normx = NORMAL;
	NORMAL = norm;
	
	
	vec2 displacement = vec2(offset);
	displacement.x *= -normx.x*2.0;
	displacement.y *= -normx.y*2.0;
	vec4 alpha = vec4(1.0);
	alpha = texture(SCREEN_TEXTURE ,SCREEN_UV + displacement );
	
	
	
	
	
	
	ALBEDO = mix(alpha.rgb,albedo.rgb,albedo.a);
	SPECULAR = specular;
	ALPHA = opacity;
	
	
	
}