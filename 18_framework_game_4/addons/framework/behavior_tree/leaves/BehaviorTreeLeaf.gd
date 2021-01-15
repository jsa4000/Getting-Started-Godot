@tool
class_name BehaviorTreeLeaf extends BehaviorTreeNode
@icon("../../icons/action.svg")

func _get_configuration_warning():
	var result = PackedStringArray()
	if get_child_count() != 0:
		result.append("nodes %s should not have children" % name)
	return String("\n").join(result)
