@tool
class_name Vector2Control extends BaseControl

var value: Vector2 = Vector2(0,0):
	set = set_value, get = get_value

@onready var _scalar_x : BaseControl = $Layout/ScalarX
@onready var _scalar_y : BaseControl = $Layout/ScalarY

func _ready():
	super()
	set_value(value)

func get_value() -> Vector2:  
	return value

func set_value(val : Vector2): 
	if value == val:
		return
	value = val
	if _scalar_x != null:
		_scalar_x.set_value(value.x)
	if _scalar_y != null:
		_scalar_y.set_value(value.y)
	self.value_changed.emit(self, value)

func _on_ScalarX_value_changed(control, val):
	value = Vector2(val, value.y)

func _on_ScalarY_value_changed(control, val):
	value = Vector2(value.x, val)
