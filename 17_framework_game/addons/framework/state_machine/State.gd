tool
extends Node
class_name State, "../icons/state.svg"

export(String) var state_name setget _set_state_name
export(bool) var start : bool = false
export(bool) var end : bool = false

var _transitions : Array = []
var _actor : Node

func _get_configuration_warning():
	var result = PoolStringArray()
	if get_child_count() < 1 && not start && not end:
		result.append("%s should have at least one child" % name)
	return result.join("\n")

func _ready():
	_set_state_name(state_name)
	call_deferred("_init_transitions")
	
func _init_transitions() -> void:
	_transitions.clear()
	for node in get_children():
		if node is Transition:
			_transitions.append(node)

func get_transition(blackboard : Dictionary) -> State:
	for transition in _transitions:
		if transition.condition(_actor, blackboard):
			return transition.state
	return null

func enter(actor : Node) -> void:
	_actor = actor
	
func exit() -> void: pass
	
func update(blackboard : Dictionary) -> void: pass
	
func handle() -> void : pass

func _set_state_name(value : String) -> void:
	state_name = value
	if state_name.empty():
		state_name = name

func _get_error(message : String) -> String:
	return  "State Error: %s" % message
