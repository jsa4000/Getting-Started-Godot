@tool
class_name CameraFpsType extends CameraMotionType

const FLOOR_NORMAL := Vector3(0, 1, 0)
const FLOOR_MAX_ANGLE: float = deg2rad(46.0)

@export var gravity : float = 30.0
@export var walk_speed : float = 10.0
@export var sprint_speed : float = 16.0
@export var acceleration : float=  8.0
@export var deacceleration : float = 10.0
@export_range(0.0, 1.0, 0.05) var air_control : float = 0.3
@export var jump_height : float = 10.0

var sprint_enabled := true
var sprinting := false

func _ready():
	pass

func _activate():
	gimbal.collision = true
	
func _deactivate():
	gimbal.collision = false

func camera_process(delta: float) -> void:
	gimbal.direction = Vector3.ZERO
	var aim: Basis = gimbal.get_global_transform().basis
	if move_axis.x >= 0.5:
		gimbal.direction -= aim.z
	if move_axis.x <= -0.5:
		gimbal.direction += aim.z
	if move_axis.y <= -0.5:
		gimbal.direction -= aim.x
	if move_axis.y >= 0.5:
		gimbal.direction += aim.x
	gimbal.direction.y = 0
	gimbal.direction = gimbal.direction.normalized()
	
	var _snap: Vector3 = Vector3.ZERO
	if gimbal.is_on_floor():
		_snap = Vector3(0, -1, 0)
		if Input.is_action_just_pressed("move_jump"):
			_snap = Vector3(0, 0, 0)
			gimbal.velocity.y = jump_height
	
	gimbal.velocity.y -= gravity * delta
	
	var _speed: int
	if (Input.is_action_pressed("move_sprint") and can_sprint() and move_axis.x >= 0.5):
		_speed = sprint_speed
		gimbal.camera.set_fov(lerp(gimbal.camera.fov, camera_fov * 1.05, delta * 8))
		sprinting = true
	else:
		_speed = walk_speed
		gimbal.camera.set_fov(lerp(gimbal.camera.fov, camera_fov, delta * 8))
		sprinting = false
	
	var _temp_vel: Vector3 = gimbal.velocity
	_temp_vel.y = 0
	var _target: Vector3 = gimbal.direction * _speed
	var _temp_accel: float
	if gimbal.direction.dot(_temp_vel) > 0:
		_temp_accel = acceleration
	else:
		_temp_accel = deacceleration
	if not gimbal.is_on_floor():
		_temp_accel *= air_control
	_temp_vel = _temp_vel.lerp(_target, _temp_accel * delta)
	gimbal.velocity.x = _temp_vel.x
	gimbal.velocity.z = _temp_vel.z
	if gimbal.direction.dot(gimbal.velocity) == 0:
		var _vel_clamp := 0.25
		if abs(gimbal.velocity.x) < _vel_clamp:
			gimbal.velocity.x = 0
		if abs(gimbal.velocity.z) < _vel_clamp:
			gimbal.velocity.z = 0

	var moving = gimbal.move_and_slide_with_snap(gimbal.velocity, _snap, FLOOR_NORMAL, true, 4, FLOOR_MAX_ANGLE)
	if gimbal.is_on_wall():
		gimbal.velocity = moving
	else:
		gimbal.velocity.y = moving.y
		
	if noise_enabled:
		var noise = _compute_noise_position(gimbal.global_transform.origin)
		gimbal.camera.translation.x = noise.x * noise_translation_amount
		gimbal.camera.rotation = noise * noise_rotation_amount	
			
func can_sprint() -> bool:
	return (sprint_enabled and gimbal.is_on_floor())
