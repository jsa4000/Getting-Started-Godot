tool
extends TransitionDecorator
class_name NegateTransitionDecorator, "../../icons/inverter.svg"

func condition(actor : Node, blackboard : Dictionary) -> bool: 
	return not .condition(actor,blackboard)
