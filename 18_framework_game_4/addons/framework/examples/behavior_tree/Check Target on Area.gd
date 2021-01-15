@tool
extends BehaviorTreeConditionLeaf

@export_placeholder var target : String = "player"
@export_range(0,100,0.1) var distance : float =  0

func eval(actor : Node, blackboard : Dictionary) -> int:
	var node = blackboard[target]
	if (node.global_transform.origin - actor.global_transform.origin).length() <= distance:
		return SUCCESS
	return FAILURE
