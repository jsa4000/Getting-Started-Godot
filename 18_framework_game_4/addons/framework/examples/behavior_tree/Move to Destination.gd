@tool
extends BehaviorTreeTaskLeaf

const DELTA = "delta"

@export_placeholder var destination : String = "destination"
@export_range(0.0,5.0,0.1) var speed : float = 0.5

func eval(actor : Node, blackboard : Dictionary) -> int:
	var node = blackboard[destination]
	
	actor.global_transform.origin = actor.global_transform.origin.lerp(node.global_transform.origin, speed * blackboard[DELTA])
	
	return SUCCESS
