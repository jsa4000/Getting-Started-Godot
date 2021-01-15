class_name SelectionByGroup extends Selection

@export_placeholder var group_name : String

func get_object(parent: Node) -> Object:
	var result = parent.get_tree().get_nodes_in_group(group_name)
	if result is Array && result.size() == 1:
		result= result[0]
	return result
