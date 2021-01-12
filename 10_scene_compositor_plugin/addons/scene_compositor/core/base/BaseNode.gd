tool
extends GraphNode
class_name BaseNode

const DefaultMinimizedSize = Vector2(100,100)

const CustomStyleFrame = preload("res://addons/scene_compositor/ui/styles/CustomStyleFrame.tres")
const CustomStyleSelectedFrame = preload("res://addons/scene_compositor/ui/styles/CustomStyleSelectedFrame.tres")

export(Color) var color_frame : Color = Color.white setget set_color_frame

var _type : String setget ,get_type
var _path : String setget ,get_node_path
var _kind : int setget ,get_kind

var _is_minimized = false
var _children = []

var _data = {}

func get_type() -> String: return _type
func get_node_path() -> String: return _path
func get_kind() -> int: return _kind

onready var _title_dialog = $TitleDialog
onready var _preview_image = $PreviewImage

signal closed

func set_color_frame(value):
	color_frame = value
	_set_color_frame(value)
	
func init(type : String, path : String, kind : int):	
	_type = type
	_path = _path
	_kind = kind
	
func _ready():
	_set_color_frame(color_frame)
	connect("close_request", self, "_on_close_request")
	connect("resize_request", self, "_on_resize_request")
	connect("gui_input", self, "_on_gui_input")
	rect_size = Vector2.ZERO

func get_data() -> Node: return null

func has_inputs() -> bool:
	return _has_connections(Global.ConnectorType.INPUT)

func has_outputs() -> bool:
	return _has_connections(Global.ConnectorType.OUTPUT)

func add_input(slot: int, to: BaseNode, to_slot: int):
	_add_connection(slot, Global.ConnectorType.INPUT, to, to_slot)
		
func remove_input(slot: int, to: BaseNode, to_slot: int):
	_remove_connection(slot, Global.ConnectorType.INPUT, to, to_slot)
	
func add_output(slot: int, to: BaseNode, to_slot: int):
	_add_connection(slot, Global.ConnectorType.OUTPUT, to, to_slot)
		
func remove_output(slot: int, to: BaseNode, to_slot: int):
	_remove_connection(slot, Global.ConnectorType.OUTPUT, to, to_slot)
	
func execute():
	_initialize()
	if not _validate():
		return
	_execute()
	_finalize()

func update_layout():
	_on_resize_request(rect_min_size)	
	
func get_slot(slot: int, conn_type : int) -> SlotControl:
	for control in _get_slots(conn_type):
		if control.get_slot() == slot:
			return control
	return null

func save_data() -> Dictionary: 
	var data = {
		"name" : name,
		"title": title,
		"type" : _type,
		"path" : _path,
		"kind" : _kind,
		"offset" : Serializer.encode(offset),
		"size" : Serializer.encode(rect_size),
		"min_size" : Serializer.encode(rect_min_size),
		"minimized" : _is_minimized,
		"slots" : []
	}
	for slot in get_children():
		if slot is SlotControl:
			data["slots"].append(slot.save_data())
	return data
	
func load_data(data : Dictionary): 
	name = data["name"]
	title = data["title"]
	offset = Serializer.decode(data["offset"])
	rect_size = Serializer.decode(data["size"])
	rect_min_size = Serializer.decode(data["min_size"])
	for slot_data in data["slots"]:
		var slot = get_slot(slot_data["slot"], slot_data["connection_type"])
		slot.load_data(slot_data)
	
func _on_close_request():
	emit_signal("closed", self)

func _on_resize_request(new_minsize):
	_set_content_size(new_minsize)
	rect_size.x = new_minsize.x

func _on_gui_input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_RIGHT && event.pressed:
		_title_dialog.activate(title, Vector2(rect_size.x, 30), rect_global_position)
	if event is InputEventMouseButton && event.doubleclick:
		_minimize()

func _on_TitleDialog_closed(value):
	title = value
	
func _on_value_requested(control, name : String):
	#print("[%s] Value requested on node %s. Property: %s" % [self.title, control.get_parent().title, name])
	if control is SlotControl && control.get_connection_type() == Global.ConnectorType.OUTPUT:
		execute()
	
func _on_value_changed(control, value):
	#print("[%s] Value changed on control %s. Value = %s" % [self.title, control.get_parent().title, value])
	if control is SlotControl && control.get_connection_type() != Global.ConnectorType.OUTPUT:
		execute()

func _set_content_size(size): pass
	
func _get_definition() -> Dictionary: return {}

func _initialize(): 
	_data = {}
	_evaluate_slots(Global.ConnectorType.INPUT)
	_evaluate_slots(Global.ConnectorType.NONE)
	_initialize_slots(Global.ConnectorType.OUTPUT)
	
func _validate() -> bool: return true

func _execute(): pass
	
func _finalize():
	_evaluate_slots(Global.ConnectorType.OUTPUT)
	#print(_to_string())
	
func _evaluate_slots(conn_type : int):
	var def_conn = _get_definition_connection(conn_type)
	for slot in def_conn:
		var def = def_conn[slot]
		if def.has("var"):
			var control = get_slot(slot, conn_type)
			if conn_type == Global.ConnectorType.OUTPUT:
				if not _data.has(def["var"]):
					print("Output %s has not been computed." % def["var"])
					continue
				#print("Setting value %s in node %s and control %s for variable %s" % [_data[def["var"]], self.title, control, def["var"]])
				control.set_value(_data[def["var"]])
			else:
				#print("Getting value from control %s in node %s for variable %s" % [control, self.title,def["var"]])
				_data[def["var"]] = control.get_value()
				
func _initialize_slots(conn_type : int):
	var def_conn = _get_definition_connection(conn_type)
	for slot in def_conn:
		var def = def_conn[slot]
		if def.has("var"):
			var control = get_slot(slot, conn_type)
			control.initialize()
			
func _minimize():
	if _is_minimized:	
		for child in _children:
			add_child(child)
		rect_size = DefaultMinimizedSize
	else	:
		_children.clear()
		for child in get_children():
			_children.append(child)
			remove_child(child)
		rect_size = DefaultMinimizedSize
	_is_minimized = !_is_minimized

func _set_color_frame(color : Color):
	if not is_inside_tree():
		return
	var style = CustomStyleFrame.duplicate()
	style.set_border_color(color)
	set("custom_styles/frame", style)
	style = CustomStyleSelectedFrame.duplicate()
	style.set_border_color(color)
	set("custom_styles/selectedframe", style)

func _add_connection(slot: int, conn_type : int, to: BaseNode, to_slot: int):
	var control = get_slot(slot, conn_type) 
	if control && conn_type == Global.ConnectorType.INPUT:
		control.add_remote(to.get_slot(to_slot, Global.ConnectorType.OUTPUT))
		
func _remove_connection(slot: int, conn_type : int, to: BaseNode, to_slot: int):
	var control = get_slot(slot, conn_type) 
	if control && conn_type == Global.ConnectorType.INPUT:
		control.remove_remote(to.get_slot(to_slot, Global.ConnectorType.OUTPUT))

func _has_connections(conn_type : int) -> bool:
	for control in _get_slots(conn_type):
		if control.has_remote():
			return true
	return false

func _get_definition_connection(conn_type : int) -> Dictionary:
	var conn_def
	match conn_type:
		Global.ConnectorType.INPUT:
			conn_def = "inputs"
		Global.ConnectorType.OUTPUT:
			conn_def = "outputs"
		_:
			conn_def = "extra"
	var definition = _get_definition()
	if definition.has(conn_def):
		return definition[conn_def]
	return {}

func _get_slots(conn_type : int) -> Array:
	var slots = []
	for child in get_children():
		if child is SlotControl && child.get_connection_type() == conn_type:
			slots.append(child)
	return slots

func _to_string() -> String:
	var value = PoolStringArray()
	value.append("node: {")
	value.append("   name: { %s }," % name)
	value.append("   title: { %s }," % title)
	value.append("   inputs: { %s }," % _to_string_slots(Global.ConnectorType.INPUT))
	value.append("   outputs: { %s }," % _to_string_slots(Global.ConnectorType.OUTPUT))
	value.append("   none: { %s }," % _to_string_slots(Global.ConnectorType.NONE))
	value.append("}")
	return value.join("\n")

func _to_string_slots(conn_type : int):
	var value = PoolStringArray()
	var def_conn = _get_definition_connection(conn_type)
	for slot in def_conn:
		var def = def_conn[slot]
		for item in def:
			value.append("%s:%s" % [item, def[item]])	
		if _data.has(def["var"]):
			value.append("data:%s" % [_data[def["var"]]])
	return value.join(", ")
