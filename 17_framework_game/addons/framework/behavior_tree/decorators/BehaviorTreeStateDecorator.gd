tool
extends BehaviorTreeDecorator
class_name BehaviorTreeStateDecorator, "../../icons/state.svg"

export(String) var state_name setget _set_state_name
export(bool) var start : bool = false
export(bool) var end : bool = false
export(Array,NodePath) var transition_states

var _transitions : Array = []

func _ready():
	_set_state_name(state_name)
	call_deferred("_init_transitions")
	
func eval(actor : Node, blackboard : Dictionary) -> int:
	return get_child(0).eval(actor, blackboard)

func get_transitions() -> Array:
	return _transitions

func _init_transitions() -> void:
	_transitions.clear()
	for path in transition_states:
		var node = get_node(path)
		if node != null && node is BehaviorTreeNode:
			_transitions.append(node)

func _set_state_name(value : String) -> void:
	state_name = value
	if state_name.empty():
		state_name = name
		
