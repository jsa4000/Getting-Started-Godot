@tool
class_name CameraExternalType extends CameraType

@export_node_path var camera_path : NodePath
@export_placeholder var sub_path : String = ""

var _camera : Camera3D 

func _ready() -> void:
	_camera = _parent.get_node(_get_path(camera_path, sub_path))
	
func _activate() -> void:
	gimbal.camera.current = false
	_camera.current = true
	
func _deactivate() -> void:
	_camera.current = false
	gimbal.camera.current = true

func _get_path(base_path : NodePath, sub_path : String) -> NodePath:
	if sub_path.is_empty():
		return base_path
	else:
		return NodePath("%s/%s" % [str(base_path),sub_path])
	
