class_name SelectionByNodePath extends Selection

@export_node_path var node_path : NodePath
@export_placeholder var sub_path : String

func get_object(parent: Node) -> Object:
	var path = _get_path(node_path, sub_path)
	var result = parent.get_node(path)
	return result

func _get_path(base_path : NodePath, sub_path : String) -> NodePath:
	if sub_path.is_empty():
		return base_path
	else:
		return NodePath("%s/%s" % [str(base_path),sub_path])
	
