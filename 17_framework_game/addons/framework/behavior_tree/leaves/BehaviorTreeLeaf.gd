tool
extends BehaviorTreeNode
class_name BehaviorTreeLeaf, "../../icons/action.svg"

func _get_configuration_warning():
	var result = PoolStringArray()
	if get_child_count() != 0:
		result.append("nodes %s should not have children" % name)
	return result.join("\n")
