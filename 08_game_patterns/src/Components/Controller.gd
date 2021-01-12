tool
extends Component
class_name Controller

const COMPONENT_NAME : String = "controller"
const COMPONENT_GROUP : String = "controllers"

var _executor : Executor = ExecutorQueue.new() setget ,get_executor
var _actions : Dictionary = Dictionary() setget ,get_actions

func get_executor(): return _executor
func get_actions(): return _actions

func get_action(name: String) -> Action: 
	if not _actions.has(name):
		logger.error("Action %s has not been found on controller %s" % name)
		return null;
	return _actions[name]

func _init().():
	_component_name = COMPONENT_NAME
	_component_group = COMPONENT_GROUP
	add_to_group(_component_group)

func _ready():
	_initialize_actions()
	_initialize_executor()	

func handle(action : Action):
	_executor.add(action)
	_executor.execute()
		
func _initialize_actions():
	_actions = _get_nodes_in_group(Action.GROUP) 

func _initialize_executor():	
	add_child(_executor)
	_executor.connect("action_finished",self, "_on_action_finished" )

func _on_action_finished(action, error):
	pass

func to_string():
	var string = PoolStringArray()
	for key in _actions: string.append(key)
	return "%s: [%s]" % [_component_name, string.join(", ")]
