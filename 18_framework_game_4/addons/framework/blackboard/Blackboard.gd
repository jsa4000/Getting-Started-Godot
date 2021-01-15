@tool
class_name Blackboard extends Repository
@icon("../icons/blackboard.svg")

@export var data : Dictionary = {}

var _clients : Dictionary = {}
var _data : Dictionary = {}

func _ready() -> void:
	if Engine.is_editor_hint():
		return
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

func set_value(key, value) -> void:
	_data[key] = value

func get_value(key):
	return _data[key]

func has(key) -> bool:
	return _data.has(key)

func erase(key) -> void:
	_data.erase(key)

