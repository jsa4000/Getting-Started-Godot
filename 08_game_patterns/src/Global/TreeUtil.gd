extends Node
class_name TreeUtil

static func get_nodes_in_group(parent: Node, group: String) -> Array:
	var result := Array()
	for node in parent.get_children():
		if node.is_in_group(group):
				result.append(node)
		if node.get_child_count() > 0:
			result += get_nodes_in_group(node, group)
	return result
