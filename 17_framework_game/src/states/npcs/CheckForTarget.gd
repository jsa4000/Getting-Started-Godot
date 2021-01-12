extends Transition

export(String) var target : String = "player"
export(float,0,100,0.1) var distance : float =  0

func condition(actor : Node, blackboard : Dictionary) -> bool: 
	var node = blackboard[target]
	if (node.global_transform.origin - actor.global_transform.origin).length() <= distance:
		return true
	return false
