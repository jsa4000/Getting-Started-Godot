tool
extends Node
class_name StateMachine, "../icons/state_machine.svg"

signal state_changed(status)

export (bool) var enabled = true setget _set_enabled
export(NodePath) var actor_path : NodePath setget _set_actor_path
export(Dictionary) var data = {}

var state : String setget _set_state,_get_state

var _current_state : State setget _set_current_state
var _actor : Node
var _blackboard : Dictionary = {}
var _states : Dictionary = {}  
var _initialized : bool = false

func _get_configuration_warning():
	var result = PoolStringArray()
	if get_child_count() < 1:
		result.append("%s should have at least one child" % name)
	return result.join("\n")

func _init():
	add_to_group(StateMachineGlobal.STATE_MACHINE_GROUP)

func _ready():
	_set_enabled(enabled)
	_set_actor_path(actor_path)
	if Engine.is_editor_hint():
		return
	call_deferred("_init_blackboard")
	call_deferred("_init_states")
	
func _init_states() -> void:
	_states.clear()
	var initial_state : State = null
	for node in get_children():
		if node is State:
			_states[node.state_name] = node
			if node.start:
				initial_state = node
	if initial_state == null:
		if get_child_count() == 0:
			return
		initial_state = get_child(0)
	_change_state(initial_state)

func _init_blackboard() -> void:
	_blackboard = SelectionUtils.get_data_from_node(self, data)
	_initialized = true
	
func _physics_process(delta):
	if not enabled || Engine.is_editor_hint() || _current_state == null || not _initialized:
		return
	update({"delta" : delta})
	
func update(parameters : Dictionary = {}) -> void:
	var new_state = _current_state.get_transition(_blackboard)
	if new_state != null:
		_change_state(new_state)
	for param in parameters:
		_blackboard[param] = parameters[param]
	_current_state.update(_blackboard)
	
func _change_state(new_state : State) -> void:
	if new_state != _current_state:
		_set_current_state(new_state)
		emit_signal("state_changed",  _current_state.state_name)
		
func _set_enabled(value : bool) -> void:
	enabled = value
	set_process(enabled)
	set_physics_process(enabled)

func _set_actor_path(value : NodePath) -> void:
	actor_path = value
	if not is_inside_tree():
		return
	_actor = get_node_or_null(actor_path)
	if _actor == null:
		_actor = get_parent()
		if _actor != null:
			actor_path = _actor.get_path()

func _set_current_state(value : State):
	if _current_state == value:
		return
	if _current_state != null:
		_current_state.exit()
	_current_state = value
	if _current_state != null:
		_current_state.enter(_actor)	

func _get_state() -> String:
	if _current_state != null:
		return _current_state.state_name
	return ""

func _set_state(value : String) -> void:
	state = value
	if value != null && _states.has(state):
		_current_state = _states[state]
	
