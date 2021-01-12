extends Transition
		
func condition(actor : Node, blackboard : Dictionary) -> bool: 
	if Input.is_action_just_pressed("ui_accept"):
		return true
	return false
