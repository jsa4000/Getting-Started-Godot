@tool
class_name BehaviorTreeSequenceComposite extends BehaviorTreeComposite
@icon("../../icons/sequencer.svg")

func eval(actor : Node, blackboard : Dictionary) -> int:
	for node in get_children():
		var response = node.eval(actor, blackboard)
		if response != SUCCESS:
			return response
	return SUCCESS
