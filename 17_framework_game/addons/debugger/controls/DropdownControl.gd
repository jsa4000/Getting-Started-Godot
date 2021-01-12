tool
extends BaseControl
class_name DropdownControl

export (String) var value : String = "" setget set_value, get_value
export (String) var options : String = "" setget set_options, get_options

onready var _list : OptionButton = $List

func _ready():
	set_value(value)
	set_options(options)

func get_value() -> String:  
	return value

func set_value(val : String):  
	value = val
	if _list != null:
		_list.selected = _get_id_from_text(value)
	emit_signal("value_changed", self, get_value())

func set_options(value : String): 	
	_list.clear()
	if not value:
		return
	var enums = value.split(",",false)
	for i in range(enums.size()):
		_list.add_item(enums[i],i)
	pass
	
func get_options() -> String: 	
	if _list == null:
		return ""
	var options = PoolStringArray()
	for i in range(_list.get_item_count()):
		options.append(_list.get_item_text(i))
	return options.join(",")

func _on_List_item_selected(index):
	if _list.get_selected_id() == -1:
		value = ""
	value = _list.get_item_text(_list.get_selected_id())
	emit_signal("value_changed", self, get_value())

func _get_id_from_text(text: String) -> int:
	for i in range(_list.get_item_count()):
		if _list.get_item_text(i) == text:
			return i
	return -1


