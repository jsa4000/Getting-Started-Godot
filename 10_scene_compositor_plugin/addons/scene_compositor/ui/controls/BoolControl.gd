tool
extends BaseControl
class_name BoolControl

var exports_definition = [
	{"name":"value", "type": TYPE_BOOL, "setget": "set_value,get_value"},	
]

onready var _button : Button = $Button

func _get_exports_definition() -> Dictionary:
	return exports_definition

func get_value() -> bool:  
	return _button.pressed

func set_value(value : bool): 	
	_button.pressed = value
	emit_signal("value_changed", self, value)

func _on_Button_pressed():
	emit_signal("value_changed", self, get_value())
