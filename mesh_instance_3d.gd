extends MeshInstance3D

@onready var sun = get_node("Sun") as DirectionalLight3D
@onready var mat := mesh.surface_get_material(0) as ShaderMaterial


const SIZE := 50

func _ready() -> void:
	var waves := PackedFloat32Array()
	var frequencies := PackedFloat32Array()
	var directions := PackedVector2Array()

	var base_amplitude := 1.0
	var base_frequency := 0.2
	var roughness := 0.55     # controls decay
	var lacunarity := 1.9     # frequency growth

	var rng = RandomNumberGenerator.new()
	rng.randomize()

	for i in range(SIZE):
		var amplitude = base_amplitude * pow(roughness, i)
		var frequency = base_frequency * pow(lacunarity, i)
		var direction = Vector2(rng.randf_range(-2.0, 2.0), rng.randf_range(-2.0, 2.0))
		var direction_normalized := direction.normalized()

		amplitude *= rng.randf_range(0.8, 1.2)
		frequency *= rng.randf_range(0.9, 1.1)



		waves.append(amplitude)
		frequencies.append(frequency)
		directions.append(direction_normalized)

	print("waves:", waves)
	print("frequencies:", frequencies)
	print("directions:", directions)

	if mat:
		mat.set_shader_parameter("waves", waves)
		mat.set_shader_parameter("frequencies", frequencies)
		mat.set_shader_parameter("wave_directions", directions)
func _process(_delta: float) -> void:
	pass
