extends BehaviorTreeTaskLeaf

export(String) var destination : String = "destination"
export(float,0.0,5.0,0.1) var speed : float = 0.5

func eval(actor : Node, blackboard : Dictionary) -> int:
	var node = blackboard[destination]
	
	actor.global_transform.origin = actor.global_transform.origin.linear_interpolate(node.global_transform.origin, speed * blackboard.delta)
	
	return SUCCESS
