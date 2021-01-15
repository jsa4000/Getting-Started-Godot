@tool
class_name BehaviorTreeParallelComposite extends BehaviorTreeComposite
@icon("../../icons/parallel.svg")

func eval(actor : Node, blackboard : Dictionary) -> int:
	for node in get_children():
		var response = node.eval(actor, blackboard)
		if response != FAILURE:
			return response
	return FAILURE
