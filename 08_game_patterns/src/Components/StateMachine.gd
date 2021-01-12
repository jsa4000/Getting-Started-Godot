tool
extends Component
class_name StateMachine

const COMPONENT_NAME : String = "state_machine"
const COMPONENT_GROUP : String = "state_machines"

export(String) var initial_state: String
var _states : Dictionary = Dictionary() setget , get_states

var _previous_state : State
var _state : State setget , get_state

func get_states(): return _states
func get_state(): return _state

func _init().():
	_component_name = COMPONENT_NAME
	_component_group = COMPONENT_GROUP
	add_to_group(_component_group)

func _ready():
	_initialize_states()

func _physics_process(delta):
	if _state:
		_state.update(delta)
		
func set_state(value : State, action: Action, parameters : Dictionary):
	_previous_state = _state
	_state = value
	if _previous_state:
		_previous_state.exit(_state, action, parameters)
	if _state:
		_state.enter(_previous_state, action, parameters)	
		
func _initialize_states():
	_states = _get_nodes_in_group(State.GROUP)
	for key in _states:
		_states[key].connect("state_changed",self, "_on_state_changed" )	
		
func _set_initial_state() -> void:
	if not initial_state || not _states.has(initial_state):
		logger.error("Initial State %s was not found in the entity" % initial_state, self)
		return
	self.set_state(_states[initial_state], null, {})

func _on_state_changed(new_state, action, parameters) -> void:
	if not _states.has(new_state):
		logger.error("State %s was not found in the entity" % new_state, self)
		return
	logger.debug("Changed to state %s and parameters %s" % [new_state,parameters], self)
	self.set_state(_states[new_state], action, parameters if parameters else {})

func to_string():
	var string = PoolStringArray()
	for key in _states: string.append(key)
	return "%s: [%s]" % [_component_name, string.join(", ")]
