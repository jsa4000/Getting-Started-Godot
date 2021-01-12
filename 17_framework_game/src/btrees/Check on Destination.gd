extends BehaviorTreeConditionLeaf

export(String) var destination : String = "destination"
export(float,0,2,0.1) var proximity : float = 0.5

func eval(actor : Node, blackboard : Dictionary) -> int:
	if not blackboard.has(destination):
		return SUCCESS
	var node = blackboard[destination]
	if (actor.global_transform.origin - node.global_transform.origin).length() <= proximity:
		return SUCCESS
	return FAILURE
