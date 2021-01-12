tool
extends Transition
class_name TransitionDecorator, "../../icons/transition.svg"

func _get_configuration_warning():
	var result = PoolStringArray()
	if get_child_count() != 1:
		result.append("nodes %s should have only one child" % name)
	return result.join("\n")

func condition(actor : Node, blackboard : Dictionary) -> bool: 
	return get_child(0).condition(actor, blackboard)

func get_state() -> Node:
	if Engine.is_editor_hint():
		return null
	return get_child(0).state
	
func set_state(value: Node) -> void:
	if Engine.is_editor_hint():
		return
	state = get_child(0).state
