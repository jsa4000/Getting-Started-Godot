@tool
class_name CameraMotionType extends CameraType

@export_range(0,10) var height : float = 1.7
@export var mouse_sensitivity : float = 12.0

var move_axis := Vector2.ZERO
var mouse_axis := Vector2.ZERO

func _ready():
	pass

func activate() -> void: 
	_set_capture_mouse(true)
	_set_camera_fov(camera_fov)
	_set_gimbal_height(height)
	_activate()

func deactivate() -> void: 
	_set_capture_mouse(false)
	_set_gimbal_height(0)
	_deactivate()

func process(delta: float) -> void:
	move_axis.x = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	move_axis.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

func input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_0):
		if not Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_set_capture_mouse(true)
		else:
			_set_capture_mouse(false)

	if event is InputEventMouseMotion:
		mouse_axis = event.relative
		_set_camera_rotation()
	
func _set_camera_rotation() -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if mouse_axis.length() > 0:
		var horizontal: float = -mouse_axis.x * (mouse_sensitivity / 100)
		var vertical: float = -mouse_axis.y * (mouse_sensitivity / 100)
		mouse_axis = Vector2()
		
		gimbal.rotate_y(deg2rad(horizontal))
		gimbal.pivot.rotate_x(deg2rad(vertical))
		
		var temp_rot: Vector3 = gimbal.pivot.rotation_degrees
		temp_rot.x = clamp(temp_rot.x, -90, 90)
		gimbal.pivot.rotation_degrees = temp_rot

func _set_capture_mouse(enabled : bool) -> void:
	if enabled && not Engine.is_editor_hint():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _set_gimbal_height(value : float) -> void:
	gimbal.height = value
