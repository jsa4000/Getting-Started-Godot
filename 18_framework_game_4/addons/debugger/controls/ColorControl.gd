@tool
extends BaseControl
class_name ColorControl

var value : Color = Color.white:
	set = set_value, get = get_value

@onready var _button = $Button

func _ready():
	super()
	set_value(value)

func get_value() -> Color:  
	return value

func set_value(val : Color): 
	if value == val:
		return
	value = val
	if _button != null:
		_button.color = value
	self.value_changed.emit(self, value)

func _on_Button_color_changed(color):
	value = color
