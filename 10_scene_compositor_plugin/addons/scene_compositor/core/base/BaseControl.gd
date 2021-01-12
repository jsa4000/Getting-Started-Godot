tool
extends HBoxContainer
class_name BaseControl

enum SetgetMethod { SETTER, GETTER }

var _id : int setget set_id, get_id

func set_id(value : int): _id = value
func get_id() -> int: return _id

signal value_changed(control, value)	
		
func get_value(): return null
func set_value(value): pass

func _get_exports_definition() -> Dictionary: return {}

func _get(property):
	if not is_inside_tree():
		return null
	var exports = _get_exports_definition()
	for def in exports:
		if def.name != property:
			continue
		var getter = _get_setget_method(def, SetgetMethod.GETTER)
		if not getter.empty():
			return call(getter)
		var path = NodePath(def.path)
		if not has_node(path):	
			#if not path.get_concatenated_subnames().empty():
			#	path = path.get_concatenated_subnames()
			return get_indexed(path)
		return get_node(path).get_indexed(path.get_concatenated_subnames())

func _set(property, value):
	if not is_inside_tree():
		return false
	var exports = _get_exports_definition()
	for def in exports:
		if def.name != property:
			continue
		var setter = _get_setget_method(def, SetgetMethod.SETTER)
		if not setter.empty():
			call(setter, value)
			return true
		var path = NodePath(def.path)
		if not has_node(path):
			#if not path.get_concatenated_subnames().empty():
			#	path = path.get_concatenated_subnames()
			set_indexed(path, value)
		else:
			get_node(path).set_indexed(path.get_concatenated_subnames(), value)
		return true
	return false

func _get_property_list():
	var properties = []
	var exports = _get_exports_definition()
	for def in exports:
		var property = {
			"hint": PROPERTY_HINT_NONE if not def.has("values") else PROPERTY_HINT_ENUM,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": def.name,
			"type": def.type
		}
		if def.has("values"):
			property["hint_string"] = def["values"]
		properties.append(property)
	return properties

func _get_setget_method(def : Dictionary, setget_method : int = SetgetMethod.SETTER) -> String:
	if not def.has("setget"):
		return ""
	var sg = def["setget"].split(",")
	if sg.size() < SetgetMethod.size() || sg[setget_method].empty():
		return ""
	return sg[setget_method]
