shader_type spatial;

const int SAMPLES = 50;
uniform float amplitudes[SAMPLES];
uniform float frequencies[SAMPLES];
uniform vec2 wave_directions[SAMPLES];
uniform float phases[SAMPLES];

uniform vec3 deep_color : source_color = vec3(0.0, 0.3, 0.6);
uniform vec3 shallow_color : source_color = vec3(0.0, 0.4, 0.0);

varying vec3 view_space_normal;

void vertex() {
    vec2 pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz;
    
    float height = 0.0;
    float dy_dx = 0.0;
    float dy_dz = 0.0;

    for (int i = 0; i < 32; i++) {
        float amplitude = amplitudes[i];
        float freq = frequencies[i];
        vec2 d = wave_directions[i];
        float phase = phases[i];

        float spatial_term = dot(pos, d) * freq;
        float wave_arg = spatial_term + (TIME * freq * 4.0) + phase;
        
        float s = sin(wave_arg);
        float c = cos(wave_arg);
        float exp_sin = exp(s - 1.0); 
        
        height += amplitude * exp_sin;
        

        float derivative = amplitude * exp_sin * c * freq;
        dy_dx += derivative * d.x;
        dy_dz += derivative * d.y;
    }

    VERTEX.y += height;


    vec3 world_normal = normalize(vec3(-dy_dx, 1.0, -dy_dz));
    


    view_space_normal = (VIEW_MATRIX * vec4(world_normal, 0.0)).xyz;
}

void fragment() {

    NORMAL = normalize(view_space_normal);

    float fresnel = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 3.0);
    
    // ALBEDO = mix(deep_color, shallow_color, fresnel);
    ALBEDO = deep_color ;
    
    ROUGHNESS = 0.1;
    METALLIC = 0.8;
}
