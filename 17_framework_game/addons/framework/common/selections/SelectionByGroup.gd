extends Selection
class_name SelectionByGroup

export(String) var group_name : String

func get_object(parent: Node) -> Object:
	assert(group_name != null, _get_error("A group name must be provided"))
	var result = parent.get_tree().get_nodes_in_group(group_name)
	assert(not result.empty(), _get_error("No occurrences has been found for group %s" % group_name))
	if result is Array && result.size() == 1:
		result= result[0]
	return result
