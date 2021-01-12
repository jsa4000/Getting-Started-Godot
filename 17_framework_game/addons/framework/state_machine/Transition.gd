tool
extends Node
class_name Transition, "../icons/transition.svg"

export(NodePath) var state_path : NodePath setget _set_state_path

var state : Node setget set_state,get_state

func _ready():
	_set_state_path(state_path)

func _get_configuration_warning():
	var result = PoolStringArray()
	if get_child_count() != 0:
		result.append("nodes %s should not have children" % name)
	return result.join("\n")

func condition(actor : Node, blackboard : Dictionary) -> bool: 
	return false

func _set_state_path(value: NodePath) -> void:
	state_path = value
	state = get_node_or_null(state_path)
	
func _get_error(message : String) -> String:
	return  "Transition Error: %s" % message

func set_state(value: Node) -> void:
	state = value

func get_state() -> Node:
	return state
	
