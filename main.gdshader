shader_type spatial;





const float sampling_step = 1.0;

uniform float waves[50];

uniform float frequencies[50];

uniform vec2 wave_directions[50];



uniform vec3 deep_color : source_color = vec3(0.0, 0.1, 0.2);
uniform vec3 shallow_color : source_color = vec3(0.1, 0.4, 0.7);
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform float roughness : hint_range(0.0, 1.0) = 0.02; // Keep low for water





float signal_sin(float x, float z, float time, float freq_spatial, float freq_time) {



  float y = 0.0;

  for (int i = 0; i < 30; i++) {
      float amplitude = waves[i];
      float freq = frequencies[i];
      vec2 d = wave_directions[i];

      float spatial_term = (x * d.x + z * d.y) * freq;
      y += amplitude * exp(sin(spatial_term + time * freq_time));
  }


  return y;
}


float get_height(vec2 pos, float time, float freq) {
    return signal_sin(pos.x, pos.y, time, freq, freq * 2.0f);
}

void vertex() {
    float freq = 1.4;
    vec2 pos = VERTEX.xz;

    float height = get_height(pos, TIME, freq);
    VERTEX.y += height;


    float h_right = get_height(pos + vec2(sampling_step, 0.0), TIME, freq);
    float h_left  = get_height(pos - vec2(sampling_step, 0.0), TIME, freq);
    float h_up    = get_height(pos + vec2(0.0, sampling_step), TIME, freq);
    float h_down  = get_height(pos - vec2(0.0, sampling_step), TIME, freq);
    

    vec3 normal_local = normalize(vec3(h_left - h_right, sampling_step * 2.0, h_down - h_up));
    NORMAL = normal_local;

}

void fragment() {
    // 1. FRESNEL CALCULATION
    // This makes the water darker/transparent looking down, and reflective at the horizon.
    float fresnel = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 3.0);
    
    // 2. MIX COLORS BASED ON ANGLE
    vec3 color = mix(deep_color, shallow_color, fresnel);
    
    ALBEDO = color;
    METALLIC = metallic;
    ROUGHNESS = roughness;
    SPECULAR = 0.5;
    
    // 3. ADD "SHIMMER" (Optional but recommended)
    // Adding a tiny bit of "Rim" or Emission based on fresnel helps it pop
    EMISSION = color * fresnel * 0.2;
}



// void light() {
//
//     float lambert = max(0.0, dot(NORMAL, LIGHT));
//     DIFFUSE_LIGHT += ALBEDO * lambert * ATTENUATION;
//
//
//     vec3 halfway_dir = normalize(LIGHT + VIEW);
//
//
//     float spec_pow = pow(max(0.0, dot(NORMAL, halfway_dir)), 64.0);
//
//
//
//     SPECULAR_LIGHT += LIGHT_COLOR * spec_pow * 2.0f * lambert * ATTENUATION;
// }
//
//
//
