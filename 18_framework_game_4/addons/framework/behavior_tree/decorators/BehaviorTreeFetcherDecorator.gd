@tool
class_name BehaviorTreeFetcherDecorator extends BehaviorTreeDecorator
@icon("../../icons/download.svg")

@export var data : Dictionary= {}

var _data : Dictionary
var _initialized : bool = false

func _ready():
	if Engine.is_editor_hint():
		return
	call_deferred("_init_data")
	
func eval(actor : Node, blackboard : Dictionary) -> int:
	if not _initialized:
		return FAILURE
	for key in _data:
		blackboard[key] = _data[key]
	return get_child(0).eval(actor, blackboard)

func _init_data() -> void:
	_data = SelectionUtils.get_data_from_node(self, data)
	_initialized = true

func _get_error(message : String) -> String:
	return  "BehaviorTreeFetcher Error: %s" % message
