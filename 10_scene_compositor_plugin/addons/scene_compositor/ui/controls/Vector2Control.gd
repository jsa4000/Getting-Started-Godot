tool
extends BaseControl
class_name Vector2Control

var exports_definition = [
	{"name":"value","type": TYPE_VECTOR2, "setget": "set_value,get_value"},	
]

onready var _scalar_x : BaseControl = $Layout/ScalarX
onready var _scalar_y : BaseControl = $Layout/ScalarY

func _get_exports_definition() -> Dictionary:
	return exports_definition

func get_value() -> Vector2:  
	return Vector2(_scalar_x.get_value(), _scalar_y.get_value())

func set_value(value : Vector2): 	
	_scalar_x.set_value(value.x)
	_scalar_y.set_value(value.y)
	emit_signal("value_changed", self, value)

func _on_ScalarX_value_changed(control, value):
	emit_signal("value_changed", self, get_value())

func _on_ScalarY_value_changed(control, value):
	emit_signal("value_changed", self, get_value())
