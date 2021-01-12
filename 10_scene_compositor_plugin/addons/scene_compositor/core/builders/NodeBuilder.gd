tool
extends Reference
class_name NodeBuilder

enum NodeKind {SCENE, SCRIPT}
const BaseNodeScene = preload("res://addons/scene_compositor/core/base/BaseNode.tscn")
const SlotControlScene = preload("res://addons/scene_compositor/core/base/SlotControl.tscn")

var _controls = ControlLoader.new().get_resources()
var _nodes = NodeLoader.new().get_resources()

var _type : String
var _node : BaseNode

func type(type : String) -> NodeBuilder:
	_type = type
	return self

func build() -> BaseNode:
	_node = _create_node()
	return _node

func _build() -> BaseNode:	
	var definition = _node._get_definition()
	_node.title = definition.title
	_node.set_color_frame(definition.color)
	var slot_idx = _node.get_child_count() - 1
	slot_idx = _create_slots(Global.ConnectorType.OUTPUT, slot_idx)
	slot_idx = _create_slots(Global.ConnectorType.NONE, slot_idx)
	slot_idx = _create_slots(Global.ConnectorType.INPUT, slot_idx)
	return _node	

func _create_node() -> BaseNode:
	var resource = _nodes[_type]
	var kind = get_kind(resource)
	match kind:
		NodeKind.SCRIPT:
			_node = BaseNodeScene.instance()
			_node.set_script(resource)
			_build()
		NodeKind.SCENE, _:
			_node = resource.instance()
	_node.init(_type, resource.resource_path, kind)
	return _node

func get_kind(resource : Resource):
	if resource is PackedScene:
		return  NodeKind.SCENE
	return  NodeKind.SCRIPT

func _create_slots(conn_type : int = Global.ConnectorType.NONE, slot_idx :int = -1) -> int:
	var conn_def = _node._get_definition_connection(conn_type)
	if not conn_def.empty():
		for slot in conn_def:
			_create_slot(slot, conn_def[slot], slot_idx, conn_type)
			slot_idx += 1
	return slot_idx

func _create_slot(slot : int, data : Dictionary, slot_idx :int = -1, conn_type : int =  Global.ConnectorType.NONE) -> SlotControl:
	var definition = _node._get_definition()
	var control = SlotControlScene.instance()
	control.set_id(slot_idx)
	control.set_text_label(data.name)
	control.set_slot(slot, conn_type)
	_node.add_child(control)
	if data.has("editable") && data.editable == true:
		if data.has("control"):
			control.set_control(_controls[data.control].instance())
		else:
			control.set_control(_controls[Global.DataTypeControl[data.type]].instance())
	if data.has("label"):
		control.set_hide_label(!data.label)
	if data.has("var"):
		control.set_property(data["var"])
	if data.has("parameters") && control.has_control():
		var parameters = data["parameters"]
		for parameter in parameters:	
			control.get_control().call_deferred("set", parameter, Serializer.decode(parameters[parameter]))
	if data.has("default"):
		control.set_value(Serializer.decode(data["default"]))
		if control.has_control():
			control.get_control().call_deferred("set_value", Serializer.decode(data["default"]))
	var color = data.color if data.has("color") else Global.DataTypeColor[data.type]
	if definition.has("label_min_size"):
		control.set_min_size_label(Vector2(definition.label_min_size[0], definition.label_min_size[1]))
	match conn_type:
		Global.ConnectorType.INPUT:
			control.set_align_label(SlotControl.Align.LEFT)
			control.set_slot(slot, conn_type)
			_node.set_slot (slot_idx, true, data.type, color, false, 0, Color.black)
		Global.ConnectorType.OUTPUT:
			control.set_align_label(SlotControl.Align.RIGHT)	
			control.set_slot(slot, conn_type)
			_node.set_slot (slot_idx, false, 0, Color.black, true, data.type, color)
		_:
			control.set_align_label(LabelControl.Align.LEFT)
			control.set_slot(slot, Global.ConnectorType.NONE)
	control.connect("value_requested", _node, "_on_value_requested")
	control.connect("value_changed", _node, "_on_value_changed")
	return control

