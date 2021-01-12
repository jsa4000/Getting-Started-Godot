tool
extends BaseControl
class_name SliderControl

var exports_definition = [
	{"name":"value", "type": TYPE_REAL, "setget": "set_value,get_value"},
	{"name":"slider/max_value", "path": "Layout/Slider:max_value", "type": TYPE_REAL},
	{"name":"slider/min_value", "path": "Layout/Slider:min_value", "type": TYPE_REAL},
	{"name":"slider/step", "path": "Layout/Slider:step", "type": TYPE_REAL}
]

onready var _scalar : BaseControl = $Layout/Scalar
onready var _slider : Slider = $Layout/Slider
	
func _get_exports_definition() -> Dictionary:
	return exports_definition

func get_value() -> float:  
	return _scalar.get_value()

func set_value(value : float): 	
	_scalar.set_value(value)
	_slider.value = value
	emit_signal("value_changed", self, value)

func _on_Slider_value_changed(value):
	_scalar.set_value(value)
	emit_signal("value_changed", self, get_value())

func _on_Scalar_value_changed(control, value):
	_slider.value = value
	
