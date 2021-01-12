extends PanelContainer
class_name DebugPanel, "../icons/icon_panel.svg"

export(String) var title : String
export(NodePath) var target : NodePath setget _set_target
export(bool) var lock : bool

var _resources : Dictionary = ControlLoader.new().get_resources()
var _scroll_container : ScrollContainer = ScrollContainer.new()
var _controls : VBoxContainer = VBoxContainer.new()
var _target : Node

func _get_definition() -> Dictionary: return {}

func _init():
	add_to_group(Global.DEBUG_GROUP)

func _ready():
	_set_target(target)
	_add_controls()
	call_deferred("_initialize")

func _get_configuration_warning():
	return ""

func _initialize():
	var definition = _get_definition()
	if definition.empty():
		return
	for id in definition.controls:
		var control = _get_control_by_id(id)
		var control_def = definition.controls[id]
		control.value = _get_value(control_def.path)
		
func _on_value_changed(control, value):
	if _target == null:
		return
	var definition = _get_definition()
	if definition.empty():
		return
	var control_def = _get_control_definition(control.id)
	call_deferred("_set_value", control_def.path, value)
	check_control_dependencies(control.id, value)
	
func check_control_dependencies(id, value):
	var control_def = _get_control_definition(id)
	if control_def.type != Global.DataType.BOOL:
		return
	for child in _controls.get_children():
		if child is BaseControl:
			var def = _get_control_definition(child.id)
			if def.has("depends_on"):
				if def.depends_on == id:
					child.visible = value
	
func _get_control_by_id(id):
	for child in _controls.get_children():
		if child is BaseControl:
			if child.id == id:
				return child
				
func _get_control_by_name(name):
	var definition = _get_definition()
	if definition.empty():
		return
	for id in definition.controls:
		if definition.controls[id].name == name:
			return _get_control_by_id(id)
	return null

func _get_control_definition(id):
	var definition = _get_definition()
	if definition.empty():
		return
	return definition.controls[id]

func _add_controls():
	var definition = _get_definition()
	if definition.empty():
		return
	title = definition.title
	add_child(_scroll_container)
	_scroll_container.add_child(_controls)
	_scroll_container.scroll_horizontal_enabled = false
	_set_size_flags(self)
	_set_size_flags(_scroll_container)
	_set_size_flags(_controls)
	for id in definition.controls:
		_add_control(id)

func _add_control(id):
	var definition = _get_definition()
	var data = definition.controls[id]
	var control
	if data.has("control"):
		control = _resources[data.control].instance()
	else:
		control = _resources[Global.DataTypeControl[data.type]].instance()
	_controls.add_child(control)
	control.id = id
	control.text_label = data.name
	if data.has("label"):
		control.hide_label = !data.label
	if data.has("parameters"):
		var parameters = data["parameters"]
		for parameter in parameters:	
			control.call_deferred("set", parameter, Serializer.decode(parameters[parameter]))
	if data.has("default"):
		control.call_deferred("set_value", Serializer.decode(data["default"]))
	if definition.has("label_min_size"):
		control.min_size_label = Vector2(definition.label_min_size[0], definition.label_min_size[1])
	control.align_label = BaseControl.Align.LEFT
	control.connect("value_changed", self, "_on_value_changed")

func _set_size_flags(control : Control) -> void:
	control.rect_clip_content = true
	control.size_flags_horizontal = SIZE_EXPAND_FILL
	control.size_flags_vertical = SIZE_EXPAND_FILL

func _get_value(node_path):
	var path = NodePath(node_path)
	if not _target.has_node(path):
		return _target.get_indexed(path)
	else:
		return _target.get_node(path).get_indexed(path.get_concatenated_subnames())

func _set_value(node_path, value):
	var path = NodePath(node_path)
	if not _target.has_node(path):
		_target.set_indexed(path, value)
	else:
		_target.get_node(path).set_indexed(path.get_concatenated_subnames(), value)

func _set_target(value : NodePath):
	target = value
	if target.is_empty():
		_target = get_parent()
	else:
		_target = get_node_or_null(target)
		
