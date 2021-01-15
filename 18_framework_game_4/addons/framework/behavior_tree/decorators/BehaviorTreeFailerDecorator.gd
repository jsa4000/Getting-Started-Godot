@tool
class_name BehaviorTreeFailerDecorator extends BehaviorTreeDecorator
@icon("../../icons/fail.svg")

func eval(actor : Node, blackboard : Dictionary) -> int:
	var response = get_child(0).eval(actor, blackboard)
	if response == RUNNING:
		return RUNNING
	return FAILURE
