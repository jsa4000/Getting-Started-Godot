extends BehaviorTreeTaskLeaf

export(String) var counter : String = "counter"

func eval(actor : Node, blackboard : Dictionary) -> int:
	if not blackboard.has(counter):
		blackboard[counter] = 0
	blackboard[counter] += 1
	return SUCCESS
