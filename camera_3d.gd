extends Camera3D

@export var sensitivity := 0.002
@export var max_pitch := deg_to_rad(85)

var yaw := 0.0
var pitch := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity

		pitch = clamp(pitch, -max_pitch, max_pitch)

		rotation = Vector3(pitch, yaw, 0)


	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

@export var speed := 80.0

func _process(delta: float) -> void:
	var dir := Vector3.ZERO

	if Input.is_key_pressed(KEY_W):
		dir -= transform.basis.z
	if Input.is_key_pressed(KEY_S):
		dir += transform.basis.z
	if Input.is_key_pressed(KEY_A):
		dir -= transform.basis.x
	if Input.is_key_pressed(KEY_D):
		dir += transform.basis.x

	global_position += dir.normalized() * speed * delta
