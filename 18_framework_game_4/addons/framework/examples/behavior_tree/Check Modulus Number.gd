@tool
extends BehaviorTreeConditionLeaf

@export_placeholder var number : String = "counter"
@export_range(0,100) var modulus : int = 1

func eval(actor : Node, blackboard : Dictionary) -> int:
	if blackboard.has(number) && blackboard[number] % modulus == 0:
		return SUCCESS
	return FAILURE
