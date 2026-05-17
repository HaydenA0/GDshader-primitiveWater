extends MeshInstance3D

@onready var mat := mesh.surface_get_material(0) as ShaderMaterial

const SIZE := 50




@export var max_wavelength := 80.0
@export var min_wavelength := 0.9
@export var global_steepness := 0.2

func _ready() -> void:
	var amplitudes := PackedFloat32Array()
	var frequencies := PackedFloat32Array()
	var directions := PackedVector2Array()
	var phases := PackedFloat32Array()

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	

	for i in range(SIZE):
		var min_freq = (2.0 * PI) / max_wavelength
		var max_freq = (2.0 * PI) / min_wavelength
		

		var t = float(i) / float(SIZE - 1)
		var frequency = lerp(min_freq, max_freq, pow(t, 1.5))
		

		frequency *= rng.randf_range(0.9, 1.1)
		var current_steepness = global_steepness * lerp(1.0, 0.3, t)
		var amplitude = current_steepness / frequency

		var angle = rng.randf_range(0, TAU)


		var direction = Vector2(cos(angle), sin(angle)).normalized()


		var phase = rng.randf_range(0, TAU)

		amplitudes.append(amplitude)
		frequencies.append(frequency)
		directions.append(direction)
		phases.append(phase)

	if mat:
		mat.set_shader_parameter("amplitudes", amplitudes)
		mat.set_shader_parameter("frequencies", frequencies)
		mat.set_shader_parameter("wave_directions", directions)
		mat.set_shader_parameter("phases", phases)

func _process(_delta: float) -> void:
	pass
