tool
extends GraphEdit
class_name SceneCompositorGraph

const DefaultOffset = Vector2(200,100)
const AdditionalOffset = Vector2(20,20)

signal node_removed(node)
signal node_added(node)
signal connections_updated(connections)

func _ready() -> void:
	OS.low_processor_usage_mode = true
	for type in Global.DataType.values():
		add_valid_connection_type(type, Global.DataType.UNKNOWN)
		add_valid_connection_type(Global.DataType.UNKNOWN, type)

func add_node(type : String) -> BaseNode:
	var node = NodeBuilder.new().type(type).build()
	_add_node(node)
	return node
	
func get_nodes() -> Array:
	var nodes = []
	for node in get_children():
		if node is BaseNode :
			nodes.append(node)
	return nodes
	
func clean_nodes():
	for node in get_nodes():
		_remove_node(node)
		
func save_data() -> Dictionary:
	var data = {
		"name" : "name",
		"scroll_offset" : Serializer.encode(scroll_offset),
		"nodes" : [],
		"connections" : []
	}
	for node in get_nodes():
		data["nodes"].append(node.save_data())
	for connection in get_connection_list():
		data["connections"].append(connection)
	return data

func load_data(data : Dictionary):
	clean_nodes()
	scroll_offset = Serializer.decode(data["scroll_offset"])
	for node_data in data["nodes"]:
		var node = add_node(node_data["type"])
		node.load_data(node_data)
	for connection in data["connections"]:
		_connect_node(_get_node_name(connection.from), connection.from_port, _get_node_name(connection.to), connection.to_port)
		
func _on_node_closed(node):
	_remove_node(node)
	
func _on_NodeGraph_connection_request(from, from_slot, to, to_slot):
	_connect_node(from, from_slot, to, to_slot)

func _on_NodeGraph_disconnection_request(from, from_slot, to, to_slot):
	_disconnect_node(from, from_slot, to, to_slot)

func _on_NodeGraph_resized():
	_update_layout()

func _add_node(node : BaseNode):
	node.offset = _find_current_offset(DefaultOffset + scroll_offset)
	node.connect("closed",self,"_on_node_closed")
	add_child(node)
	emit_signal("node_added",node)

func _remove_node(node):
	for c in get_connection_list():
		if c.from == node.get_name() || c.to == node.get_name():
			_disconnect_node(c.from, c.from_port, c.to, c.to_port)
	node.disconnect("closed",self,"_on_node_closed")
	emit_signal("node_removed",node)
	node.queue_free()

func _connect_node(from, from_slot, to, to_slot):
	if from == to: return
	connect_node(from, from_slot, to, to_slot)
	get_node(to).add_input(to_slot, get_node(from), from_slot)
	get_node(from).add_output(from_slot, get_node(to), to_slot)
	emit_signal("connections_updated",get_connection_list())

func _disconnect_node(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)
	get_node(to).remove_input(to_slot, get_node(from), from_slot)
	get_node(from).remove_output(from_slot, get_node(to), to_slot)
	emit_signal("connections_updated",get_connection_list())

func _find_current_offset(from_offset : Vector2) -> Vector2:
	var offset  = from_offset
	for node in get_children():
		if node is BaseNode && node.offset == offset:
			return _find_current_offset(offset + AdditionalOffset)
	return offset

func _update_layout():
	for node in get_children():
		if node is BaseNode :
			node.update_layout()

func _get_node_name(name : String):
	return name.replace("@","")

