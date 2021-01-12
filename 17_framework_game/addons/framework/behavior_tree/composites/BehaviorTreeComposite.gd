tool
extends BehaviorTreeNode
class_name BehaviorTreeComposite, "../../icons/category_composite.svg"

func _get_configuration_warning():
	var result = PoolStringArray()
	if get_child_count() < 1:
		result.append("nodes %s should have at least one child" % name)
	return result.join("\n")
