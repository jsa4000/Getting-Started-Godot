@tool
extends BehaviorTreeTaskLeaf

@export_placeholder var counter : String = "counter"

func eval(actor : Node, blackboard : Dictionary) -> int:
	if not blackboard.has(counter):
		blackboard[counter] = 0
	blackboard[counter] += 1
	return SUCCESS
