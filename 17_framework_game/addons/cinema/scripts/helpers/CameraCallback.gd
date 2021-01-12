extends Resource
class_name CameraCallback

export(NodePath) var node_path : NodePath setget _set_node_path
export(String) var callback : String
export(Array, String) var parameters : Array

var _node : Node
var _parent : Node

func init(parent : Node):
	_parent = parent
	call_deferred("_set_node_path", node_path)

func invoke() -> void:
	if not _node.has_method(callback):
		return
	_node.callv(callback, parameters)
		
func _set_node_path(value : NodePath) -> void:
	node_path = value
	if _parent != null:
		_node = _parent.get_node(node_path)
