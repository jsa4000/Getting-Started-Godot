@tool
class_name BehaviorTreeDecorator extends BehaviorTreeNode
@icon("../../icons/category_decorator.svg")

func _get_configuration_warning():
	var result = PackedStringArray()
	if get_child_count() != 1:
		result.append("nodes %s should have only one child" % name)
	return String("\n").join(result)
