@tool
class_name BehaviorTreeStatesComposite extends BehaviorTreeComposite
@icon("../../icons/states.svg")

signal state_changed(status)

var state : String:
	set = _set_state, get = _get_state

var _current_node : BehaviorTreeNode
var _states : Dictionary = {}  

func _ready():
	if Engine.is_editor_hint():
		return
	call_deferred("_init_states")
	
func _init_states() -> void:
	_states.clear()
	var initial_state : BehaviorTreeNode = null
	for node in _get_nodes(_current_node):
		if node is BehaviorTreeStateDecorator:
			_states[node.state_name] = node
			if node.start:
				initial_state = node
	if initial_state == null:
		if get_child_count() == 0:
			return
		initial_state = get_child(0)
	_change_state(initial_state)

func eval(actor : Node, blackboard : Dictionary) -> int:
	var temp_node : BehaviorTreeNode
	for node in _get_nodes(_current_node):
		temp_node = node
		var response = node.eval(actor, blackboard)
		if response != FAILURE:
			_change_state(temp_node)
			return response
	_change_state(temp_node)
	return FAILURE

func _get_nodes(node : BehaviorTreeNode) -> Array:
	if node is BehaviorTreeStateDecorator && not node.get_transitions().is_empty():
		return node.get_transitions()
	else:
		return get_children()
		
func _change_state(new_node : BehaviorTreeNode) -> void:
	if new_node is BehaviorTreeStateDecorator && new_node != _current_node:
		_current_node = new_node
		state_changed.emit(_current_node.state_name)

func _get_state() -> String:
	if _current_node != null:
		return _current_node.state_name
	return ""

func _set_state(value : String) -> void:
	state = value
	if value.is_empty() && _states.has(state):
		_current_node = _states[state]
	
