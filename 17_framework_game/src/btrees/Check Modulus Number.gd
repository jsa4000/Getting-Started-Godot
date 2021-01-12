extends BehaviorTreeConditionLeaf

export(String) var number : String = "counter"
export(int) var modulus : int = 1

func eval(actor : Node, blackboard : Dictionary) -> int:
	if blackboard.has(number) && blackboard[number] % modulus == 0:
		return SUCCESS
	return FAILURE
