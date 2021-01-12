extends Transition

enum Movement {LEFT, RIGHT}

export(Movement) var movement : int = Movement.LEFT

func condition(actor : Node, blackboard : Dictionary) -> bool: 
	if Input.is_action_just_pressed(_get_input_movement(movement)):
		return true
	return false

func _get_input_movement(movement : int) -> String:
	if movement == Movement.LEFT:
		return "ui_left"
	return "ui_right"
