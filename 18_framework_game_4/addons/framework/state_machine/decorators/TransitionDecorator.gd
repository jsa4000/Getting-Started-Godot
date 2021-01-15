@tool
class_name TransitionDecorator extends Transition
@icon("../../icons/transition.svg")

func _get_configuration_warning():
	var result = PackedStringArray()
	if get_child_count() != 1:
		result.append("nodes %s should have only one child" % name)
	return String("\n").join(result)

func condition(actor : Node, blackboard : Dictionary) -> bool: 
	return get_child(0).condition(actor, blackboard)

func _get_state() -> Node:
	if Engine.is_editor_hint():
		return null
	return get_child(0).state
	
func _set_state(value: Node) -> void:
	if Engine.is_editor_hint():
		return
	state = get_child(0).state
