tool
extends Camera
class_name CameraProxy, "../icons/icon_camera.svg"

signal camera_enabled(camera)

export (String) var id : String setget _set_id
export (bool) var enabled : bool = false setget _set_enabled
export (int) var priority : int = 0
export (bool) var use_gimbal_position : bool = false
export (Resource) var type : Resource setget _set_type

var gimbal : Gimbal

func _init():
	add_to_group(CinemaGlobal.CAMERA_GROUP)

func _ready():
	_set_id(id)
	_set_enabled(false)
	_set_type(type)
	
func initialized() -> bool:
	return true if type != null && gimbal != null else false
	
func init(gimbal : Gimbal) -> void:
	self.gimbal = gimbal
	if type != null:
		type.init(self, gimbal)

func get_transform() -> Transform:
	if type.overrides_transform:
		return Transform(global_transform.basis, type.get_transform().origin + type.offset)
	else:
		return Transform(global_transform.basis, global_transform.origin + type.offset)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if initialized():
		type.camera_process(delta)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if initialized():
		type.process(delta)

func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	if initialized():
		type.input(event)

func _set_id(value : String) -> void:
	if id.empty():
		id = name
	else:
		id = value

func _set_enabled(value : bool) -> void:
	enabled = value
	_activate(enabled)
	_enable_process(enabled)
	emit_signal("camera_enabled", self)

func _set_type(value : Resource) -> void:
	type = value

func _activate(enabled : bool):
	if not initialized():
		return
	if enabled:
		type.activate()
	else:
		type.deactivate()
	
func _enable_process(enable : bool) -> void:
	set_process(enable)
	set_physics_process(enable)
	set_process_input(enable)
	set_process_unhandled_input(enable)
