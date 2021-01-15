@tool
class_name Transition extends Node
@icon("../icons/transition.svg")

@export_node_path var state_path : NodePath

var state : Node:
	set = _set_state, get = _get_state

func _ready():
	# TODO: Error in Godot 4 since exporte variables not set are null. Assigned Dummy NodePath
	_set_state_by_path(state_path)

func _get_configuration_warning():
	var result = PackedStringArray()
	if get_child_count() != 0:
		result.append("nodes %s should not have children" % name)
	return String("\n").join(result)

func condition(actor : Node, blackboard : Dictionary) -> bool: 
	return false

func _set_state_by_path(value: NodePath):
	if not value.is_empty():
		state = get_node(value)
	
func _set_state(value: Node) -> void:
	state = value

func _get_state() -> Node:
	return state
	
