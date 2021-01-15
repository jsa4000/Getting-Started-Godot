@tool
class_name NegateTransitionDecorator extends TransitionDecorator
@icon("../../icons/inverter.svg")

func condition(actor : Node, blackboard : Dictionary) -> bool: 
	# TODO: In Godot 4.0 using Super with custom funcions does not work. Use another approach
	return not super(actor,blackboard)
