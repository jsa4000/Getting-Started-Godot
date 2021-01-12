tool
extends BaseControl
class_name SpinControl

export (float) var value : float = 0.0 setget set_value, get_value

onready var _number : SpinBox = $Number

func _ready():
	set_value(value)

func get_value() -> float:  
	return value

func set_value(val : float): 	
	value = val
	if _number != null:
		_number.value = value
	emit_signal("value_changed", self, value)

func _on_Number_value_changed(val):
	value = val
	emit_signal("value_changed", self, get_value())
