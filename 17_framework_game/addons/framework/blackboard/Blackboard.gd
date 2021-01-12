extends Repository
class_name Blackboard, "../icons/blackboard.svg"

export(Dictionary) var data = {}

var _clients : Dictionary = {}
var _data : Dictionary = {}

func _ready() -> void:
	call_deferred("_init_clients")

func _init_clients() -> void:
	_clients.clear()
	var clients = get_tree().get_nodes_in_group(BlackboardGlobal.BLACKBOARD_GROUP) 
	_data = SelectionUtils.get_data_from_node(self, data)
	for client in clients:
		if not owner.is_a_parent_of(client):
			continue
		client.init(self)
		_clients[client.name] = client

func set(key, value) -> void:
	_data[key] = value

func get(key):
	return _data[key]

func has(key) -> bool:
	return _data.has(key)

func erase(key) -> void:
	 _data.erase(key)

func _get_error(message : String) -> String:
	return  "Blackboard Error: %s" % message
