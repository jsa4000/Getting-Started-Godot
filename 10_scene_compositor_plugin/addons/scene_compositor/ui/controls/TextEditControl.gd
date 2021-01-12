tool
extends BaseControl
class_name TextEditControl

var exports_definition = [
	{"name":"value", "type": TYPE_STRING, "setget": "set_value,get_value"},	
]

onready var _text : TextEdit = $Text

func _get_exports_definition() -> Dictionary:
	return exports_definition

func get_value() -> String:  
	return _text.text

func set_value(value : String): 	
	_text.text = value
	emit_signal("value_changed", self, value)

func _on_Text_focus_exited():
	emit_signal("value_changed", self, get_value())
