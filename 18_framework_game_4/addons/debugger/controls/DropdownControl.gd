@tool
class_name DropdownControl extends BaseControl

var value : String = "":
	set = set_value, get = get_value

var options : String = "":
	set = set_options, get = get_options

@onready var _list : OptionButton = $List

func _ready():
	super()
	set_value(value)
	set_options(options)

func get_value() -> String:  
	return value

func set_value(val : String):  
	if value == val:
		return
	value = val
	if _list != null:
		_list.selected = _get_id_from_text(value)
	self.value_changed.emit(self, get_value())

func set_options(value : String): 
	_list.clear()
	if value.is_empty():
		return
	var enums = value.split(",",false)
	for i in range(enums.size()):
		_list.add_item(enums[i],i)
	pass
	
func get_options() -> String: 	
	if _list == null:
		return ""
	var options = PackedStringArray()
	for i in range(_list.get_item_count()):
		options.append(_list.get_item_text(i))
	return String(",").join(options)

func _on_List_item_selected(index):
	if _list.get_selected_id() == -1:
		value = ""
	value = _list.get_item_text(_list.get_selected_id())

func _get_id_from_text(text: String) -> int:
	for i in range(_list.get_item_count()):
		if _list.get_item_text(i) == text:
			return i
	return -1


