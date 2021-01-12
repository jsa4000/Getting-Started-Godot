extends Transition

export(String) var option_selected : String = "OptionSelected"

func condition(actor : Node, blackboard : Dictionary) -> bool: 
	if not option_selected in blackboard:
		blackboard[option_selected] = 0
	if Input.is_action_just_pressed("ui_up"):
		blackboard[option_selected] -= 1
		return true
	elif Input.is_action_just_pressed("ui_down"):
		blackboard[option_selected] += 1
		return true
	return false
