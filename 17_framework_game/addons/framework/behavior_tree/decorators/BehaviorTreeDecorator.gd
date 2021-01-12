tool
extends BehaviorTreeNode
class_name BehaviorTreeDecorator, "../../icons/category_decorator.svg"

func _get_configuration_warning():
	var result = PoolStringArray()
	if get_child_count() != 1:
		result.append("nodes %s should have only one child" % name)
	return result.join("\n")
