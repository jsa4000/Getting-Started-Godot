@tool
class_name BehaviorTreeSelectorComposite extends BehaviorTreeComposite
@icon("../../icons/selector.svg")

func eval(actor : Node, blackboard : Dictionary) -> int:
	for node in get_children():
		var response = node.eval(actor, blackboard)
		if response != FAILURE:
			return response
	return FAILURE
