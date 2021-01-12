tool
extends BaseControl
class_name SpinControl

var exports_definition = [
	{"name":"value", "path": "Number:value", "type": TYPE_REAL},
	{"name":"number/max_value", "path": "Number:max_value", "type": TYPE_REAL},
	{"name":"number/min_value", "path": "Number:min_value", "type": TYPE_REAL},
	{"name":"number/step", "path": "Number:step", "type": TYPE_REAL}
]

onready var _number : SpinBox = $Number

func _get_exports_definition() -> Dictionary:
	return exports_definition

func get_value() -> float:  
	return _number.value

func set_value(value : float): 	
	_number.value = value
	emit_signal("value_changed", self, value)

func _on_Number_value_changed(value):
	emit_signal("value_changed", self, get_value())
