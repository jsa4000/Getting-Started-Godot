@tool
class_name CameraTransition extends Resource

enum TransitionType {CUT, LINEAR, CUBIC}
enum EaseType {IN, OUT, IN_OUT, OUT_IN}

@export_node_path var from_camera : NodePath
@export_node_path var to_camera : NodePath
# TODO: Godot 4.0 does not allow to especify enum types in exports
@export var transition_type : int = TransitionType.LINEAR
@export var ease_type : int = EaseType.IN_OUT
@export_range(0.0, 20.0) var duration : float = 2.0

var _from : Camera3D
var _to : Camera3D
var _tween : Tween
var _gimbal : Gimbal
var _parent : Node

func init(parent: Node, gimbal: Gimbal, tween: Tween) -> void:
	_parent = parent
	_gimbal = gimbal
	_tween = tween
	_init_cameras()
	
func _init_cameras():
	if _parent == null:
		return
	_from = _parent.get_node_or_null(from_camera)
	_to = _parent.get_node_or_null(to_camera)

func is_transition(from: Camera3D, to: Camera3D) -> bool:
	return from == _from && to == _to

func travel(to: Camera3D = null, force : bool = false) -> void:
	if to == null:
		to = _to
	if _gimbal == null || to == null || ( to.use_gimbal_position && not force):
		# TODO - Reset camera rotation?
		return
	#TODO: Godot mathc doess not work correctly
#	match(transition_type):
#		TransitionType.LINEAR, TransitionType.CUBIC:
#			_animate_transition(_gimbal, to, _to_native_transition_type(transition_type), _to_native_ease_type(ease_type) ,duration)
#		_:
#			_gimbal.global_transform.origin = to.get_transform().origin
	if transition_type == int(TransitionType.LINEAR) || transition_type == int(TransitionType.CUBIC):
		_animate_transition(_gimbal, to, _to_native_transition_type(transition_type), _to_native_ease_type(ease_type) ,duration)
	else:
		_gimbal.global_transform.origin = to.get_transform().origin

func _animate_transition(from: Node3D, to: Camera3D, trans_type: int = Tween.TRANS_LINEAR, ease_type: int = Tween.EASE_IN_OUT , time: float = 2.0) -> void:
	_tween.remove_all()
	_tween.interpolate_property(
		from, "global_transform:origin", 
		from.global_transform.origin, to.get_transform().origin, time,
		trans_type, ease_type)
	_tween.start()
	#await _tween.tween_completed

func _to_native_transition_type(type : int) -> int:
	#TODO: Godot mathc doess not work correctly
#	match(type):
#		TransitionType.LINEAR: return Tween.TRANS_LINEAR
#		TransitionType.CUBIC: return Tween.TRANS_CUBIC
#	return -1
	if type == int(TransitionType.LINEAR):
		return Tween.TRANS_LINEAR
	elif type == int(TransitionType.CUBIC):
		return Tween.TRANS_CUBIC
	return -1
	
func _to_native_ease_type(type : int) -> int:
	#TODO: Godot mathc doess not work correctly
#	match(type):
#		EaseType.IN: return Tween.EASE_IN
#		EaseType.OUT: return Tween.EASE_OUT
#		EaseType.IN_OUT: return Tween.EASE_IN_OUT
#		EaseType.OUT_IN: return Tween.EASE_OUT_IN
#	return -1
	if type == int(EaseType.IN):
		return Tween.EASE_IN
	elif type == int(EaseType.OUT):
		return Tween.EASE_OUT
	elif type == int(EaseType.IN_OUT):
		return Tween.EASE_IN_OUT
	elif type == int(EaseType.OUT_IN):
		return Tween.EASE_OUT_IN
	return -1
