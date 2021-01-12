extends Selection
class_name SelectionByNodePath

export(NodePath) var node_path : NodePath
export(String) var sub_path : String

func get_object(parent: Node) -> Object:
	var path = _get_path(node_path, sub_path)
	assert(not path.is_empty(), _get_error("A node path must be selected"))
	var result = parent.get_node(path)
	assert(result != null, _get_error("No node has been found in path %s" % path))
	return result

func _get_path(base_path : NodePath, sub_path : String) -> NodePath:
	if sub_path.empty():
		return base_path
	else:
		return NodePath("%s/%s" % [str(base_path),sub_path])
	
