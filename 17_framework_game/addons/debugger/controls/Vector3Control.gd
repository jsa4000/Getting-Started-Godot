tool
extends BaseControl
class_name Vector3Control

export (Vector3) var value: Vector3 = Vector3(0,0,0) setget set_value, get_value

onready var _scalar_x : BaseControl = $Layout/ScalarX
onready var _scalar_y : BaseControl = $Layout/ScalarY
onready var _scalar_z : BaseControl = $Layout/ScalarZ
	
func _ready():
	set_value(value)	
	
func get_value() -> Vector3:  
	return value

func set_value(val : Vector3): 	
	value = val
	if _scalar_x != null:
		_scalar_x.set_value(value.x)
	if _scalar_y != null:
		_scalar_y.set_value(value.y)
	if _scalar_z != null:
		_scalar_z.set_value(value.z)
	emit_signal("value_changed", self, value)

func _on_ScalarX_value_changed(control, val):
	value = Vector3(val, value.y, value.z)
	emit_signal("value_changed", self, get_value())

func _on_ScalarY_value_changed(control, val):
	value = Vector3(value.x, val, value.z)
	emit_signal("value_changed", self, get_value())

func _on_ScalarZ_value_changed(control, val):
	value = Vector3(value.x, value.y, val)
	emit_signal("value_changed", self, get_value())

