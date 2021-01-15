@tool
class_name BehaviorTreeStateDecorator extends BehaviorTreeDecorator
@icon("../../icons/state.svg")

@export_placeholder var state_name : String
@export var start : bool = false
@export var end : bool = false
# TODO: It must be specified NodePath in the Array as hint
@export var transition_states : Array = []

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
	if value.is_empty():
		state_name = name
		
