@tool
class_name CameraDollyType extends CameraFollowType

@export_node_path var guide_path : NodePath #setget _set_guide_path

var guide: Path3D
var _reference : Position3D
var _pathFollow : PathFollow3D

func _ready() -> void:
	super()
	overrides_transform = true
	_init_path_follow()
	_init_reference() 
	_set_guide_path(guide_path)

func get_transform() -> Transform: 
	previous_position = target.global_transform.origin
	return Transform(Basis(), _get_closest_point(previous_position))

func _translate(target: Vector3, speed: float) -> void:
	_reference.global_transform.origin = target
	gimbal.global_transform.origin = gimbal.global_transform.origin.lerp(_get_closest_point(_reference.translation) + guide.global_transform.origin, speed)
	
func _set_guide_path(value : NodePath) -> void:
	guide_path = value
	if gimbal != null && not guide_path.is_empty():
		guide = _parent.get_node(guide_path)
		#guide.add_child(_pathFollow)
		guide.add_child(_reference)

func _init_path_follow() -> void:
	_pathFollow = PathFollow3D.new()
	_pathFollow.rotation_mode = PathFollow3D.ROTATION_NONE
	_pathFollow.loop = false
	_pathFollow.cubic_interp = true

func _init_reference() -> void:
	_reference = Position3D.new()
	
func _get_closest_offset(position: Vector3) -> float:
	return guide.curve.get_closest_offset(position)

func _get_closest_point(position: Vector3) -> Vector3:
	return guide.curve.get_closest_point(position)
