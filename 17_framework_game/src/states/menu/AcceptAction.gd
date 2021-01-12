extends Transition

export(String) var action_name : String = "ActionAccepted"

func condition(actor : Node, blackboard : Dictionary) -> bool: 
	if Input.is_action_just_pressed("ui_accept"):
		blackboard[action_name] = true
	return false
