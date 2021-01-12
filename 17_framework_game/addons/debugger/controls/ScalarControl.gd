tool
extends BaseControl
class_name ScalarControl

export (float) var value : float = 0.0 setget set_value, get_value

onready var _text : LineEdit = $Text

func _ready():
	set_value(value)

func _unhandled_input(event):
	if not is_visible_in_tree ():
		return
		
	if event is InputEventKey:
		if event.scancode == KEY_ENTER:
			emit_signal("value_changed", self, get_value())
			
func get_value() -> float:  
	return value

func set_value(val : float): 	
	value = val
	var value_str = _float_to_string(value)
	if _text != null:
		_text.text = value_str
	emit_signal("value_changed", self, value)

func _on_Text_text_changed(new_text : String):
	if _is_number(new_text):	
		value = float(new_text)
	elif not new_text.empty():
		_text.text = _float_to_string(value)
	
func _on_Text_focus_exited():
	emit_signal("value_changed", self, get_value())

func _is_number(value):
	if (value is String && (value.is_valid_float() || value.is_valid_integer())) || \
		value is float || value is int:	
		return true
	return false
	
func _float_to_string(number: float):
	return "%s" % stepify(number,0.01)

