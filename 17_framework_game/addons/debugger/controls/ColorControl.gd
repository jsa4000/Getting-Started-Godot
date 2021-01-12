tool
extends BaseControl
class_name ColorControl

export (Color) var value : Color setget set_value, get_value

onready var _button = $Button

func _ready():
	set_value(value)

func get_value() -> Color:  
	return value

func set_value(val : Color): 
	value = val
	if _button != null:
		_button.color = value
	emit_signal("value_changed", self, value)

func _on_Button_color_changed(color):
	value = color
	emit_signal("value_changed", self, get_value())
