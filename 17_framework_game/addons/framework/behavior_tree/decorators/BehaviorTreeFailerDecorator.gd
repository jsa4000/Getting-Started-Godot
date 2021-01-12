tool
extends BehaviorTreeDecorator
class_name BehaviorTreeFailerDecorator, "../../icons/fail.svg"

func eval(actor : Node, blackboard : Dictionary) -> int:
	var response = get_child(0).eval(actor, blackboard)
	if response == RUNNING:
		return RUNNING
	return FAILURE
