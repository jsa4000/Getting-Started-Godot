@tool
class_name BoolControl extends BaseControl

var value : bool = false:
	set = set_value, get = get_value

@onready var _button : Button = $Button

func _ready():
	super()
	set_value(value)

func get_value() -> bool:  
	return value

func set_value(val : bool): 
	if value == val:
		return
	value = val
	if _button != null:
		_button.pressed = value
	self.value_changed.emit(self, value)

func _on_Button_pressed():
	value = _button.pressed
