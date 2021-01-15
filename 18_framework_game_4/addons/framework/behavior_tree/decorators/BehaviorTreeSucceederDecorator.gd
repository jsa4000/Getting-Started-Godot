@tool
class_name BehaviorTreeSucceederDecorator extends BehaviorTreeDecorator
@icon("../../icons/succeed.svg")

func eval(actor : Node, blackboard : Dictionary) -> int:
	var response = get_child(0).eval(actor, blackboard)
	if response == RUNNING:
		return RUNNING
	return SUCCESS
