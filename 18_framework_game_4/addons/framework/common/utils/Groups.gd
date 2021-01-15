class_name Groups

static func get_objects(node : Node, group : String, level : int = 1) -> Array:
	var results = []
	if node.is_in_group(group):
		results.append(node)
	if level < 0 || node.get_child_count() == 0:
		return results
	for child in node.get_children():
		results += get_objects(child, group, level - 1)
	return results

static func get_object(node : Node, group : String, level : int = 1) -> Node:
	if node.is_in_group(group):
		return node
	if level < 0 || node.get_child_count() == 0:
		return null
	for child in node.get_children():
		var result = get_object(child, group, level - 1)
		if result != null:
			return result
	return null

static func get_nodes_in_group(node : Node, group : String) -> Array:
	var result = []
	var nodes = node.get_tree().get_nodes_in_group(group) 
	for n in nodes:
		if not node.owner.is_a_parent_of(n):
			continue
		result.append(n)
	return result
