tool
extends BaseControl
class_name ScalarControl

var exports_definition = [
	{"name":"label/show", "path": "Label:visible", "type": TYPE_BOOL},
	{"name":"label/text", "path": "Label:text","type": TYPE_STRING},
	{"name":"value", "type": TYPE_REAL, "setget": "set_value,get_value"},	
]

var _oldtext
onready var _text : LineEdit = $Text
	
func _ready():
	_oldtext = _text.text

func _get_exports_definition() -> Dictionary:
	return exports_definition

func get_value() -> float:  
	return float(_text.text)

func set_value(value : float): 	
	var value_str = "%s" % value
	_text.text = value_str
	emit_signal("value_changed", self, value)

func _on_Text_text_changed(new_text : String):
	if _is_number(new_text):	
		_oldtext = new_text
	else:
		_text.text = _oldtext

func _is_number(value):
	if (value is String && (value.is_valid_float() || value.is_valid_integer())) || \
		value is float || value is int:	
		return true
	return false

func _on_Text_focus_exited():
	emit_signal("value_changed", self, get_value())
