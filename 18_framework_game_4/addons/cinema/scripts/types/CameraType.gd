@tool
class_name CameraType extends Resource

@export var offset : Vector3 = Vector3(0,0,0) #setget _set_offset	
@export var camera_fov : float = 80.0 #setget _set_camera_fov
@export_range(0.0, 5.0, 0.0001) var camera_fov_speed : float = 1.0
@export var noise_enabled : bool = false #setget _set_noise_enabled	
@export_range(0.0, 1.0, 0.0001) var noise_translation_amount : float = 0.05
@export_range(0.0, 1.0, 0.0001) var noise_rotation_amount : float = 0.05

var _parent : Camera3D
var _noise : OpenSimplexNoise
var overrides_transform : bool = false
var gimbal : Gimbal

func init(parent: Camera3D, gimbal : Gimbal) -> void:
	_parent = parent
	self.gimbal = gimbal
	_set_camera_fov(camera_fov)
	_ready()

func activate() -> void: _activate()

func deactivate() -> void: _deactivate()

func camera_process(delta: float) -> void: pass

func process(delta: float) -> void: pass
		
func input(event: InputEvent) -> void: pass

func get_transform() -> Transform : return Transform()

func _ready() -> void: pass

func _activate() -> void: pass

func _deactivate() -> void: pass

func _set_offset(value : Vector3) -> void:
	offset = value

func _set_noise_enabled(value : bool) -> void:
	noise_enabled = value
	if _noise == null && noise_enabled:
		_noise = _create_noise()
	
func _create_noise() -> OpenSimplexNoise:
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	return noise
	
func _compute_noise_position(position: Vector3) -> Vector3:
	if _noise == null:
		return Vector3.ZERO
	return Vector3(_noise.get_noise_1d(position.x),_noise.get_noise_1d(position.y),_noise.get_noise_1d(position.z))

func _fov(fov: float, speed: float):
	gimbal.camera.fov = lerp(gimbal.camera.fov, fov, speed)
	
func _set_camera_fov(value : float) -> void:
	camera_fov = value
	if gimbal != null:
		gimbal.camera.fov = camera_fov
