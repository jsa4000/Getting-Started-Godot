tool
extends Spatial
class_name Cinema, "../icons/icon.svg"

export (bool) var enabled : bool = true setget _set_enabled
export(NodePath) var gimbal_path
export(String) var camera_id : String setget _set_camera_id
export(Resource) var default_transition : Resource setget _set_default_transition
export(Array, Resource) var transitions : Array = []
export (bool) var motion_blur_enabled : bool = false setget _set_motion_blur_enabled
export (bool) var post_process_enabled : bool = false setget _set_post_process_enabled

onready var _gimbal: Gimbal = get_node(gimbal_path)
onready var _postprocess: Control = $PostProcess

var camera = null setget ,_get_camera
var _current : CameraProxy = null setget _set_current
var _cameras : Dictionary = {}
var _tween : Tween

func _ready() -> void:
	_init_tween()
	_set_enabled(enabled)
	_set_motion_blur_enabled(motion_blur_enabled)
	_set_post_process_enabled(post_process_enabled)
	if Engine.is_editor_hint() || not enabled:
		return
	call_deferred("_init_transitions")
	call_deferred("_init_cameras")
	
func _init_tween() -> void:
	_tween = Tween.new()
	add_child(_tween)

func _init_cameras() -> void:
	_cameras.clear()
	var nodes = get_tree().get_nodes_in_group(CinemaGlobal.CAMERA_GROUP) 
	for node in nodes:
		if not owner.is_a_parent_of(node):
			continue
		_cameras[node.id] = node
		node.init(_gimbal)
		node.connect("camera_enabled", self, "_on_camera_enabled")
	_gimbal.current = true
	_set_current(_get_next())
	default_transition.travel(_current, true)
	
func _init_transitions() -> void:
	for transition in transitions:
		transition.init(self, _gimbal,_tween)
	_set_default_transition(default_transition)
	
func _on_camera_enabled(camera) -> void:
	if _current != camera:
		_set_current(camera) 

func _set_current(value : CameraProxy) -> void:
	if _current != null:
		_current.enabled = false
	var previous = _current
	_current = value
	if _current != null:
		_current.enabled = true
		_process_transition(previous, _current) 

func _set_camera_id(value : String) -> void:
	camera_id = value
	if value != null && value in _cameras:
		_set_current(_cameras[value])

func _get_next():
	var result = null
	var priority := -1
	for key in _cameras:
		var cam = _cameras[key]
		if cam.priority >= priority && cam != _current:
			result = cam
			priority = cam.priority
	return result

func _set_enabled(value : bool) -> void:
	enabled = value
	_enable_process(enabled)
	
func _set_default_transition(value: Resource) -> void:
	default_transition = value
	if default_transition != null && not Engine.is_editor_hint():
		default_transition.init(self, _gimbal,_tween)

func _get_camera() -> Camera:
	if _gimbal == null:
		return null
	return _gimbal.camera

func _process_transition(from : CameraProxy, to: CameraProxy) -> void:
	var transition = _get_camera_transition(from, to)
	if transition == null:
		default_transition.travel(to)
	else:
		transition.travel()

func _get_camera_transition(from : Camera, to : Camera) -> CameraTransition:
	if from == null || to == null:
		return null
	for transition in transitions:
		if transition.is_transition(from, to):
			return transition
	return null

func _enable_process(enable : bool) -> void:
	set_process(enable)
	set_physics_process(enable)
	set_process_input(enable)
	set_process_unhandled_input(enable)

func _set_motion_blur_enabled(value: bool) -> void:
	motion_blur_enabled = value
	if _gimbal != null && not Engine.is_editor_hint():
		_gimbal.motion_blur_enabled = motion_blur_enabled
	
func _set_post_process_enabled(value: bool) -> void:
	post_process_enabled = value
	if _postprocess != null:
		_postprocess.visible = post_process_enabled
