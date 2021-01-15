@tool
extends BehaviorTreeTaskLeaf

@export_placeholder var counter : String = "counter"

func eval(actor : Node, blackboard : Dictionary) -> int:
	blackboard.erase(counter)
	return SUCCESS
