extends CameraType
class_name CameraExternalType

export(NodePath) var camera_path : NodePath
export(String) var sub_path : String

var _camera : Camera 

func _ready() -> void:
	_camera = _parent.get_node(_get_path(camera_path, sub_path))
	
func _activate() -> void:
	gimbal.camera.current = false
	_camera.current = true
	
func _deactivate() -> void:
	_camera.current = false
	gimbal.camera.current = true

func _get_path(base_path : NodePath, sub_path : String) -> NodePath:
	if sub_path.empty():
		return base_path
	else:
		return NodePath("%s/%s" % [str(base_path),sub_path])
	
