extends Resource
class_name CameraTransition

enum TransitionType {CUT, LINEAR, CUBIC}
enum EaseType {IN, OUT, IN_OUT, OUT_IN}

export(NodePath) var from_camera : NodePath
export(NodePath) var to_camera : NodePath
export(TransitionType) var transition_type = TransitionType.LINEAR
export(EaseType) var ease_type = EaseType.IN_OUT
export(float, 0.0, 20.0) var duration : float = 2.0

var _from : Camera
var _to : Camera
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

func is_transition(from: Camera, to: Camera) -> bool:
	return from == _from && to == _to

func travel(to: Camera = null, force : bool = false) -> void:
	if to == null:
		to = _to
	if _gimbal == null || to == null || ( to.use_gimbal_position && not force):
		# TODO - Reset camera rotation?
		return
	match(transition_type):
		TransitionType.LINEAR, TransitionType.CUBIC:
			_animate_transition(_gimbal, to, _to_native_transition_type(transition_type), _to_native_ease_type(ease_type) ,duration)
		_:
			_gimbal.global_transform.origin = to.get_transform().origin

func _animate_transition(from: Spatial, to: Camera, trans_type: int = Tween.TRANS_LINEAR, ease_type: int = Tween.EASE_IN_OUT , time: float = 2.0) -> void:
	_tween.remove_all()
	_tween.interpolate_property(
		from, "global_transform:origin", 
		from.global_transform.origin, to.get_transform().origin, time,
		trans_type, ease_type)
	_tween.start()
	yield(_tween, "tween_completed")

func _to_native_transition_type(type : int) -> int:
	match(type):
		TransitionType.LINEAR: return Tween.TRANS_LINEAR
		TransitionType.CUBIC: return Tween.TRANS_CUBIC
	return -1
	
func _to_native_ease_type(type : int) -> int:
	match(type):
		EaseType.IN: return Tween.EASE_IN
		EaseType.OUT: return Tween.EASE_OUT
		EaseType.IN_OUT: return Tween.EASE_IN_OUT
		EaseType.OUT_IN: return Tween.EASE_OUT_IN
	return -1
