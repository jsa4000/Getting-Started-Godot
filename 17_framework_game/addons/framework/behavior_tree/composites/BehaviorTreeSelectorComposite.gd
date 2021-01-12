tool
extends BehaviorTreeComposite
class_name BehaviorTreeSelectorComposite, "../../icons/selector.svg"

func eval(actor : Node, blackboard : Dictionary) -> int:
	for node in get_children():
		var response = node.eval(actor, blackboard)
		if response != FAILURE:
			return response
	return FAILURE
