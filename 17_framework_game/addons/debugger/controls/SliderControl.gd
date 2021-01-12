tool
extends BaseControl
class_name SliderControl

export (float) var value: float = 0.0 setget set_value, get_value
export (float) var max_value: float = 100.0 setget _set_max_value
export (float) var min_value: float = 0.0 setget _set_min_value
export (float) var step: float = 1.0  setget _set_step

onready var _scalar : BaseControl = $Layout/Scalar
onready var _slider : Slider = $Layout/Slider
	
func _ready():
	_set_max_value(max_value)
	_set_min_value(min_value)
	_set_step(step)
	set_value(value)

func get_value() -> float:  
	return value

func set_value(val : float):
	value = val
	if _scalar != null:
		_scalar.set_value(value)
	if _slider != null:
		_slider.value = value
	emit_signal("value_changed", self, value)

func _on_Slider_value_changed(val):
	value = val
	if _scalar != null:
		_scalar.set_value(value)
	emit_signal("value_changed", self, get_value())

func _on_Scalar_value_changed(control, val):
	value = val
	if _slider != null:
		_slider.value = value
	
func _set_max_value(value: float):
	max_value = value
	if _slider != null:
		_slider.max_value = max_value
	 
func _set_min_value(value: float):
	min_value = value
	if _slider != null:
		_slider.min_value = min_value
	
func _set_step(value: float):
	step = value
	if _slider != null:
		_slider.step = step