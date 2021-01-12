extends CameraFollowType
class_name CameraDollyType

export(NodePath) var guide_path : NodePath setget _set_guide_path

var guide: Path

var _pathFollow : PathFollow

func _ready() -> void:
	._ready()
	overrides_transform = true
	_init_path_follow()
	_set_guide_path(guide_path)

func get_transform() -> Transform: 
	previous_position = target.global_transform.origin
	return Transform(Basis(), _get_closest_point(previous_position))

func _translate(target: Vector3, speed: float) -> void:
	gimbal.global_transform.origin = gimbal.global_transform.origin.linear_interpolate(_get_closest_point(target), speed)

func _set_guide_path(value : NodePath) -> void:
	guide_path = value
	if gimbal != null && not guide_path.is_empty():
		guide = _parent.get_node(guide_path)
		guide.add_child(_pathFollow)

func _init_path_follow() -> void:
	_pathFollow = PathFollow.new()
	_pathFollow.rotation_mode = PathFollow.ROTATION_NONE
	_pathFollow.loop = false
	_pathFollow.cubic_interp = true
	
func _get_closest_offset(position: Vector3) -> float:
	return guide.curve.get_closest_offset(position)

func _get_closest_point(position: Vector3) -> Vector3:
	return guide.curve.get_closest_point(position)
