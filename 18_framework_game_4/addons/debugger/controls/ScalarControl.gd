@tool
class_name ScalarControl extends BaseControl

var value : float = 0.0:
	set = set_value, get = get_value

@onready var _text : LineEdit = $Text

func _ready():
	super()
	set_value(value)

func _unhandled_input(event):
	if not is_visible_in_tree ():
		return
		
	if event is InputEventKey:
		if event.keycode == KEY_ENTER:
			_update_value() 

func _on_Text_focus_exited():
	_update_value() 	
			
func get_value() -> float:  
	return value

func set_value(val : float): 	
	if value == val:
		return
	value = val
	var value_str = _float_to_string(value)
	if _text != null:
		_text.text = value_str
	self.value_changed.emit(self, value)

func _update_value() -> void:
	if _is_number(_text.text):	
		value = _text.text.to_float()
	elif not _text.text.is_empty():
		_text.text = _float_to_string(value)

func _is_number(value):
	if (value is String && (value.is_valid_float() || value.is_valid_integer())) || \
		value is float || value is int:	
		return true
	return false
	
func _float_to_string(number: float):
	return "%s" % snapped(number,0.01)

