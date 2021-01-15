@tool
class_name StateMachine extends Node
@icon("../icons/state_machine.svg")

signal state_changed(status)

@export var enabled : bool = true
@export_node_path var actor_path : NodePath
@export var data : Dictionary = {}

var state : String:
	set = _set_state, get = _get_state

var _current_state : State:
	set = _set_current_state
	
var _actor : Node
var _blackboard : Dictionary = {}
var _states : Dictionary = {}  
var _initialized : bool = false

func _get_configuration_warning():
	var result = PackedStringArray()
	if get_child_count() < 1:
		result.append("%s should have at least one child" % name)
	return String("\n").join(result)

func _init():
	add_to_group(StateMachineGlobal.STATE_MACHINE_GROUP)

func _ready():
	_set_enabled(enabled)
	_set_actor_by_path(actor_path)
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
	
func _change_state(new_state: State) -> void:
	if new_state != _current_state:
		_set_current_state(new_state)
		state_changed.emit(_current_state.state_name)

func _set_enabled(value : bool) -> void:
	set_process(value)
	set_physics_process(value)

func _set_actor_by_path(value : NodePath) -> void:
	_actor = get_node_or_null(value)
	if _actor == null:
		_actor = get_parent()

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
	if not value.is_empty() && _states.has(state):
		_current_state = _states[state]
	
