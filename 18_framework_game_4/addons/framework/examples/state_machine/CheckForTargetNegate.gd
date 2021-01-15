@tool
extends Transition

@export_placeholder var target : String = "player"
@export_range(0,100,0.1) var distance : float =  1

func condition(actor : Node, blackboard : Dictionary) -> bool: 
	var node = blackboard[target]
	if (node.global_transform.origin - actor.global_transform.origin).length() <= distance:
		return false
	return true
