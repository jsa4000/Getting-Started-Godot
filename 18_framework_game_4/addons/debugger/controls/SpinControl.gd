@tool
class_name SpinControl extends BaseControl

var value : float = 0.0:
	set = set_value, get = get_value

@onready var _number : SpinBox = $Number

func _ready():
	super()
	set_value(value)

func get_value() -> float:  
	return value

func set_value(val : float): 	
	if value == val:
		return
	value = val
	if _number != null:
		_number.value = value
	self.value_changed.emit(self, value)

func _on_Number_value_changed(val):
	value = val
