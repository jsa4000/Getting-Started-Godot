@tool
class_name Vector3Control extends BaseControl

var value: Vector3 = Vector3(0,0,0):
	set = set_value, get = get_value

@onready var _scalar_x : BaseControl = $Layout/ScalarX
@onready var _scalar_y : BaseControl = $Layout/ScalarY
@onready var _scalar_z : BaseControl = $Layout/ScalarZ
	
func _ready():
	super()
	set_value(value)	
	
func get_value() -> Vector3:  
	return value

func set_value(val : Vector3): 	
	if value == val:
		return
	value = val
	if _scalar_x != null:
		_scalar_x.set_value(value.x)
	if _scalar_y != null:
		_scalar_y.set_value(value.y)
	if _scalar_z != null:
		_scalar_z.set_value(value.z)
	self.value_changed.emit(self, value)

func _on_ScalarX_value_changed(control, val):
	value = Vector3(val, value.y, value.z)

func _on_ScalarY_value_changed(control, val):
	value = Vector3(value.x, val, value.z)

func _on_ScalarZ_value_changed(control, val):
	value = Vector3(value.x, value.y, val)

