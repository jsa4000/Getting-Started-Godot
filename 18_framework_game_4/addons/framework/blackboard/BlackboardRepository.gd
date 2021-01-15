@tool
class_name BlackboardRepository extends Repository
@icon("../icons/blackboard_client.svg")

@export var data : Dictionary = {}

var _blackboard : Repository
var _initialized : bool = false

func _init():
	add_to_group(BlackboardGlobal.BLACKBOARD_GROUP)

func init(blackboard: Repository) -> void:
	_blackboard = blackboard
	if Engine.is_editor_hint():
		return
	call_deferred("_init_data")
	
func _init_data() -> void:
	# TODO: In Godot 4.0 it must be added a default key/value in order to work
	var tmpdata = SelectionUtils.get_data_from_node(self, data)
	for key in tmpdata:
		set_value(key, tmpdata[key])
	_initialized = true

func is_initialized() -> bool:
	return _initialized

func set_value(key, value) -> void:
	_blackboard.set_value(key, value)

func get_value(key):
	return _blackboard.get_value(key)

func has(key) -> bool:
	return _blackboard.has(key)

func erase(key) -> void:
	_blackboard.erase(key)

