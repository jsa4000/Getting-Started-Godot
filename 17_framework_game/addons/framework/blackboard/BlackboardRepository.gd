extends Repository
class_name BlackboardRepository, "../icons/blackboard_client.svg"

export(Dictionary) var data = {}

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
	var tmpdata = SelectionUtils.get_data_from_node(self, data)
	for key in tmpdata:
		set(key, tmpdata[key])
	_initialized = true

func is_initialized() -> bool:
	return _initialized

func set(key, value) -> void:
	_blackboard.set(key, value)

func get(key):
	return _blackboard.get(key)

func has(key) -> bool:
	return _blackboard.has(key)

func erase(key) -> void:
	 _blackboard.erase(key)

