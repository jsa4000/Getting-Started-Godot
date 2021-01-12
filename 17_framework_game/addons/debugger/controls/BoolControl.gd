tool
extends BaseControl
class_name BoolControl

export (bool) var value : bool = false setget set_value, get_value

onready var _button : Button = $Button

func _ready():
	set_value(value)

func get_value() -> bool:  
	return value

func set_value(val : bool): 
	value = val
	if _button != null:
		_button.pressed = value
	emit_signal("value_changed", self, value)

func _on_Button_pressed():
	value = _button.pressed
	emit_signal("value_changed", self, get_value())
