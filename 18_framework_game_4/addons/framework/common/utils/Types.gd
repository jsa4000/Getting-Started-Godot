class_name Types

static func get_objects(node : Node, type, level : int = 1) -> Array:
	var results = []
	if node is type:
		results.append(node)
	if level < 0 || node.get_child_count() == 0:
		return results
	for child in node.get_children():
		results += get_objects(child, type, level - 1)
	return results

static func get_object(node : Node, type , level : int = 1) -> Node:
	if node is type:
		return node
	if level < 0 || node.get_child_count() == 0:
		return null
	for child in node.get_children():
		var result = get_object(child, type, level - 1)
		if result != null:
			return result
	return null
