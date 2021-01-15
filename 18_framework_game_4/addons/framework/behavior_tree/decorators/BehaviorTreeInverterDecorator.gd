@tool
class_name BehaviorTreeInverterDecorator extends BehaviorTreeDecorator
@icon("../../icons/inverter.svg")

func eval(actor : Node, blackboard : Dictionary) -> int:
	var response = get_child(0).eval(actor, blackboard)
	if response == SUCCESS:
		return FAILURE
	if response == FAILURE:
		return SUCCESS
	return RUNNING
