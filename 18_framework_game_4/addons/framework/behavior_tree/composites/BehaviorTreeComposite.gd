@tool
class_name BehaviorTreeComposite extends BehaviorTreeNode
@icon("../../icons/category_composite.svg")

func _get_configuration_warning():
	var result = PackedStringArray()
	if get_child_count() < 1:
		result.append("nodes %s should have at least one child" % name)
	return String("\n").join(result)
